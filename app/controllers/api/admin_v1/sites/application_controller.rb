# frozen_string_literal: true

class API::AdminV1::Sites::ApplicationController < API::AdminV1::ApplicationController
  before_action :set_site
  # before_action :require_site_creator! # TODO: ENABLE IT LATER
  skip_before_action :authenticate_user! # TODO: REMOVE IT LATER

  private

    def set_site
      @site = Site.find(params[:site_id])
    end

    def require_site_creator!
      unless @site.creator == current_user
        render status: :forbidden,
               json: {
                 status: "error",
                 error: {
                   type: "Forbidden",
                   data: nil
                 }
               }
      end
    end
end
