# frozen_string_literal: true

class API::ClientV1::Sites::PageViewsController < API::ClientV1::Sites::ApplicationController
  def index
    @page_views = current_client.page_views.page(params[:page]).per(params[:per_page])

    render json: {
      status: "ok",
      page_views: @page_views.map { |pv| render_page_view pv },
      pagination: {
        current_page: @page_views.current_page,
        total_count: Client.first.page_views.size,
        per_page: 25
      }
    }
  end

  private

    def render_page_view(pv)
      {
        created_at: pv.created_at,
        host: pv.host,
        path: pv.path,
        payload: pv.serializable_hash,
        ref_count: 1,
        status: :persisted
      }
    end
end
