# frozen_string_literal: true

module API
  module ClientV1
    class ApplicationController < ::ApplicationController
      protected

        def authenticate_client!
          unless current_client
            render status: :unauthorized,
                   json: {
                     status: "error",
                     error: {
                       type: "ClientFingerprintMissingOrInvalid",
                       data: nil
                     }
                   }
          end
        end

        def current_client
          @current_client ||=
            begin
              return if request.headers["X-Client-Fingerprint"].blank?

              Client.find_by fingerprint: request.headers["X-Client-Fingerprint"]
            end
        end
    end
  end
end
