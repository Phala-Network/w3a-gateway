# frozen_string_literal: true

module API
  module V1
    class ApplicationController < ::ApplicationController
      before_action :authenticate_user!

      rescue_from ActionController::ParameterMissing do |exception|
        render status: :bad_request,
               json: {
                 status: "error",
                 error: {
                   type: "ParameterMissing",
                   data: exception.param
                 }
               }
      end

      protected

        def authenticate_user!
          unless current_user
            render status: :unauthorized,
                   json: {
                     status: "error",
                     error: {
                       type: "AccessTokenMissingOrInvalid",
                       data: nil
                     }
                   }
          end
        end

        def current_access_token
          @current_access_token ||=
            begin
              return if request.headers["X-Access-Token"].blank?

              access_token = AccessToken.find_by token: request.headers["X-Access-Token"]
              if access_token.nil? || access_token.revoked? || access_token.expired?
                return
              end

              access_token
            end
        end

        def current_user
          @current_user ||=
            begin
              return unless current_access_token

              uid = request.headers["X-UID"]
              if uid.blank?
                return
              end

              user = User.find_by uid: uid
              unless user
                return
              end

              return if current_access_token.user_id != user.id

              return if user.disabled?

              user
            end
        end
    end
  end
end
