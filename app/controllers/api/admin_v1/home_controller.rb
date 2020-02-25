# frozen_string_literal: true

class API::AdminV1::HomeController < API::AdminV1::ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    render json: {
      status: "ok"
    }
  end

  def me
    render json: {
      user: {
        email: current_user.email,
        public_key: current_user.public_key,
        created_at: current_user.created_at
      }
    }
  end
end
