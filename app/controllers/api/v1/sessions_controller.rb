# frozen_string_literal: true

class API::V1::SessionsController < API::V1::ApplicationController
  MAX_PENDING_REQUEST = 5

  skip_before_action :authenticate_user!, only: %i[new create update]

  def new
    email = params[:email]
    unless email.present?
      render status: :bad_request,
             json: {
               status: "error",
               error: {
                 type: "ParameterMissing",
                 data: "email"
               }
             }

      return
    end

    user = User.find_by email: email
    unless user
      render status: :not_found,
             json: {
               status: "error",
               error: {
                 type: "ResourceNotFound",
                 data: nil
               }
             }

      return
    end

    signature = params[:signature]
    unless signature.present?
      render status: :bad_request,
             json: {
               status: "error",
               error: {
                 type: "SignatureMissing",
                 data: nil
               }
             }

      return
    end

    # Verify signature
    public_key = Secp256k1::PublicKey.new(pubkey: [user.public_key].pack("H*"), raw: true)
    signature_raw = public_key.ecdsa_deserialize([signature].pack("H*"))
    _had_to_normalize, normalized_sig_raw = public_key.ecdsa_signature_normalize(signature_raw)
    unless public_key.ecdsa_verify(email, normalized_sig_raw)
      render status: :bad_request,
             json: {
               status: "error",
               error: {
                 type: "SignatureInvalid",
                 data: nil
               }
             }

      return
    end

    # if user.access_requests.pending.size > MAX_PENDING_REQUEST
    #   render status: :forbidden,
    #          json: {
    #            status: "error",
    #            error: {
    #              type: "RequestTooMany",
    #              data: nil
    #            }
    #          }
    #
    #   return
    # end

    begin
      @access_request = user.access_requests.create!

      render json: {
        status: "ok",
        data: {
          request_token: @access_request.request_token,
          expires_at: @access_request.expires_at
        }
      }
    rescue ActiveRecord::RecordInvalid
      render status: :unprocessable_entity,
             json: {
               status: "error",
               error: {
                 type: "Unknown",
                 data: nil
               }
             }
    end
  end

  def create
    email = params[:email]
    unless email.present?
      render status: :bad_request,
             json: {
               status: "error",
               error: {
                 type: "ParameterMissing",
                 data: "email"
               }
             }

      return
    end

    signature = params[:signature]
    unless signature.present?
      render status: :bad_request,
             json: {
               status: "error",
               error: {
                 type: "SignatureMissing",
                 data: nil
               }
             }

      return
    end

    request_token = params[:request_token]
    unless request_token.present?
      render status: :bad_request,
             json: {
               status: "error",
               error: {
                 type: "ParameterMissing",
                 data: "request_token"
               }
             }

      return
    end

    @access_request = AccessRequest.find_by(request_token: request_token)
    unless @access_request
      render status: :not_found,
             json: {
               status: "error",
               error: {
                 type: "ResourceNotFound",
                 data: nil
               }
             }

      return
    end

    if @access_request.expired? || @access_request.granted?
      render status: :unauthorized,
             json: {
               status: "error",
               error: {
                 type: "RequestTokenInvalid",
                 data: nil
               }
             }

      return
    end

    user = @access_request.user
    unless user
      render status: :not_found,
             json: {
               status: "error",
               error: {
                 type: "ResourceNotFound",
                 data: nil
               }
             }

      return
    end

    if user.email != email
      render status: :unauthorized,
             json: {
               status: "error",
               error: {
                 type: "RequestTokenInvalid",
                 data: nil
               }
             }

      return
    end

    # Verify signature
    public_key = Secp256k1::PublicKey.new(pubkey: [user.public_key].pack("H*"), raw: true)
    signature_raw = public_key.ecdsa_deserialize([signature].pack("H*"))
    _had_to_normalize, normalized_sig_raw = public_key.ecdsa_signature_normalize(signature_raw)
    unless public_key.ecdsa_verify(request_token, normalized_sig_raw)
      render status: :bad_request,
             json: {
               status: "error",
               error: {
                 type: "SignatureInvalid",
                 data: nil
               }
             }

      return
    end

    @access_token = @access_request.grant!

    render json: {
      status: "ok",
      json: {
        access_token: @access_token.token,
        expires_at: @access_token.expires_at,
        refresh_token: @access_token.refresh_token
      }
    }
  rescue Secp256k1::AssertError => ex
    logger.error ex

    render status: :bad_request,
           json: {
             status: "error",
             error: {
               type: "SignatureInvalid",
               data: nil
             }
           }
  end

  def show
    render json: {
      status: "ok",
      data: {
        expires_at: current_access_token.expires_at
      }
    }
  end

  def update
    email = params[:email]
    unless email.present?
      render status: :bad_request,
             json: {
               status: "error",
               error: {
                 type: "ParameterMissing",
                 data: "email"
               }
             }

      return
    end

    refresh_token = params[:refresh_token]
    unless refresh_token.present?
      render status: :bad_request,
             json: {
               status: "error",
               error: {
                 type: "ParameterMissing",
                 data: "refresh_token"
               }
             }

      return
    end

    signature = params[:signature]
    unless signature.present?
      render status: :bad_request,
             json: {
               status: "error",
               error: {
                 type: "SignatureMissing",
                 data: nil
               }
             }

      return
    end

    @access_token = AccessToken.find_by(refresh_token: refresh_token)
    if @access_token.nil? || @access_token.revoked?
      render status: :not_found,
             json: {
               status: "error",
               error: {
                 type: "ResourceNotFound",
                 data: nil
               }
             }

      return
    end

    user = @access_token.user
    if user.nil? || user.email != email
      render status: :unauthorized,
             json: {
               status: "error",
               error: {
                 type: "ResourceNotFound",
                 data: nil
               }
             }

      return
    end

    # Verify signature
    public_key = Secp256k1::PublicKey.new(pubkey: [user.public_key].pack("H*"), raw: true)
    signature_raw = public_key.ecdsa_deserialize([signature].pack("H*"))
    _had_to_normalize, normalized_sig_raw = public_key.ecdsa_signature_normalize(signature_raw)
    unless public_key.ecdsa_verify(refresh_token, normalized_sig_raw)
      render status: :bad_request,
             json: {
               status: "error",
               error: {
                 type: "SignatureInvalid",
                 data: nil
               }
             }

      return
    end

    @access_token.extend_token!

    render json: {
      status: "ok",
      json: {
        access_token: @access_token.token,
        expires_at: @access_token.expires_at
      }
    }
  rescue Secp256k1::AssertError => ex
    logger.error ex

    render status: :bad_request,
           json: {
             status: "error",
             error: {
               type: "SignatureInvalid",
               data: nil
             }
           }
  end

  def destroy
    @current_access_token.update_attribute :revoked_at, Time.now

    render json: {
      status: "ok",
      data: nil
    }
  end
end
