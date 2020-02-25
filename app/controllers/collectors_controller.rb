# frozen_string_literal: true

class CollectorsController < ApplicationController
  def page_view
    sid = params[:sid]
    # Check SID exists
    # unless Site.exists?(sid: sid)
    #   head :bad_request
    # end

    host = params[:h]
    if host.blank?
      head :bad_request
    end

    path = params[:p]
    if path.blank?
      head :bad_request
    end

    pv = PageView.new id: SecureRandom.uuid,
                      sid: sid,
                      cid: params[:cid],
                      host: host,
                      path: path, ip: request.ip,
                      ua: request.user_agent # TODO: referrer and more.
    pv.send :create_or_update # Hack to avoid transaction

    head :no_content
  end
end
