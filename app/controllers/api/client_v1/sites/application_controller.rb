# frozen_string_literal: true

class API::ClientV1::Sites::ApplicationController < API::ClientV1::ApplicationController
  before_action :set_site

  private

    def set_site
      @site = Site.find(params[:site_id])
    end
end
