# frozen_string_literal: true

class API::V1::UsersController < API::V1::ApplicationController
  skip_before_action :authenticate_user!

  def create
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

    @user = User.new user_params

    unless @user.valid?
      render status: :unprocessable_entity,
             json: {
               status: "error",
               error: {
                 type: "EntityInvalid",
                 data: @user.errors.details
               }
             }

      return
    end

    # Verify signature
    public_key = Secp256k1::PublicKey.new(pubkey: [@user.public_key].pack("H*"), raw: true)
    signature_raw = public_key.ecdsa_deserialize([signature].pack("H*"))
    _had_to_normalize, normalized_sig_raw = public_key.ecdsa_signature_normalize(signature_raw)
    unless public_key.ecdsa_verify(@user.uid, normalized_sig_raw)
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

    unless @user.save
      render status: :unprocessable_entity,
             json: {
               status: "error",
               error: {
                 type: "EntityInvalid",
                 data: @user.errors.details
               }
             }

      return
    end

    render json: {
      status: "ok",
      data: {
        uid: @user.uid,
        public_key: @user.public_key,
        created_at: @user.created_at
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

  private

    def user_params
      params.require(:user).permit(:uid, :public_key).tap do |user_params|
        user_params.require(%i[uid public_key])
      end
    end
end
