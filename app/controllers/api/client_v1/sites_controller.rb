# frozen_string_literal: true

module API
  module ClientV1
    class SitesController < API::ClientV1::ApplicationController
      def index
        @sites = current_client.sites

        render json: {
          status: "ok",
          sites: @sites.map { |site| render_site(site) },
        }, pagination: {
          current_page: 1,
          total_count: @sites.size,
          per_page: 25
        }
      end

      def show
        @site = current_client.sites.find(params[:id])

        render json: {
          status: "ok",
          site: render_site(@site),
          data: {
            authorized: true,
            report_status: true,
            report_from: 10.days.ago,
            report_latest: Time.zone.now
          }
        }
      end

      private

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
  end
end
