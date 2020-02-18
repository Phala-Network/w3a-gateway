# frozen_string_literal: true

class API::V1::Sites::ApplicationController < API::V1::ApplicationController
  private

    def set_site
      @site = current_user.sites.find(params[:site_id])
    end
end
