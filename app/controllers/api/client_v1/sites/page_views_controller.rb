# frozen_string_literal: true

class API::ClientV1::Sites::PageViewsController < API::ClientV1::Sites::ApplicationController
  def index
    # @page_views = current_client.page_views.page(params[:page]).per(params[:per_page])
    @page_views = PageView.all.page(params[:page]).per(params[:per_page])
    if params[:created_at_start].present?
      @page_views = @page_views.where("created_at >= ?", ActiveModel::Type.lookup(:date).cast(params[:created_at_start]))
    end
    if params[:created_at_end].present?
      @page_views = @page_views.where("created_at <= ?", ActiveModel::Type.lookup(:date).cast(params[:created_at_end]))
    end
    if params[:path].present?
      @page_views = @page_views.where(path: params[:path])
    end

    render json: {
      status: "ok",
      page_views: @page_views.map { |pv| render_page_view pv },
      pagination: {
        current_page: @page_views.current_page,
        total_count: @page_views.total_count,
        per_page: params[:per_page] || 25
      }
    }
  end

  def batch_destroy
    page_view_ids = params[:page_view_ids]
    render json: {
      status: "ok",
      data: page_view_ids
    }
  end

  private

    def render_page_view(pv)
      {
        id: pv.id,
        created_at: pv.created_at,
        host: pv.host,
        path: pv.path,
        payload: pv.serializable_hash,
        ref_count: 1,
        status: :persisted
      }
    end
end
