# frozen_string_literal: true

class API::AdminV1::SitesController < API::AdminV1::ApplicationController
  before_action :set_site, only: %i[show update update destroy]

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

  def update
    if @site.update site_params_for_update
      render json: {
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
      params.require(:site).permit(:domain, :name, :description, :phala_address)
    end

    def site_params_for_update
      params.require(:site).permit(:name, :description, :phala_address)
    end

    def render_site(site)
      {
        id: site.id,
        sid: site.sid,
        domain: site.domain,
        verified: site.verified,
        name: site.name,
        description: site.description,
        phala_address: site.phala_address
      }
    end
end
