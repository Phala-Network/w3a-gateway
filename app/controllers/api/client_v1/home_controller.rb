# frozen_string_literal: true

module API
  module ClientV1
    class HomeController < API::ClientV1::ApplicationController
      def index
        render json: {
          status: "ok"
        }
      end
    end
  end
end
