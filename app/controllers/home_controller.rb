# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    render json: {
      ok: "ok"
    }
  end
end