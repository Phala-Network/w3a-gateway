# frozen_string_literal: true

class API::V1::SitesController < API::V1::ApplicationController
  before_action :set_site, only: %i[show update destroy]

  def index
    @sites = current_user.sites

    render json: {
      status: "ok",
      sites: @sites.map { |site| render_site(site) }
    }
  end

  def create
    @site = current_user.sites.build site_params
    if @site.save
      render status: :created,
             json: {
               status: "ok",
               site: render_site(@site)
             }
    else
      render status: :unprocessable_entity,
             json: {
               status: "error",
               error: {
                 type: "EntityInvalid",
                 data: @site.errors.messages
               }
             }
    end
  end

  def show
    render json: {
      status: "ok",
      site: render_site(@site)
    }
  end

  def destroy
    @site.destroy

    render json: {
      status: "ok"
    }
  end

  private

    def set_site
      @site = current_user.sites.find(params[:id])
    end

    def site_params
      params.require(:site).permit(:domain)
    end

    def render_site(site)
      {
        id: site.id,
        sid: site.sid,
        domain: site.domain,
        verified: site.verified
      }
    end
end
