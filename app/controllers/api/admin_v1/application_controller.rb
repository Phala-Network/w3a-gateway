# frozen_string_literal: true

module API
  module ApiV1
    class ApplicationController < ::ApplicationController
      before_action :authenticate_user!

      rescue_from SQLite3::BusyException do |_exception|
        ActiveRecord::Base.connection.execute("BEGIN TRANSACTION; END;")

        render status: :gateway_timeout,
               json: {
                 status: "error",
                 error: {
                   type: "DatabaseBusy",
                   data: nil
                 }
               }
      end

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

              email = request.headers["X-Email"]
              if email.blank?
                return
              end

              user = User.find_by email: email
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
