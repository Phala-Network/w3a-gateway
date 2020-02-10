# frozen_string_literal: true

class CollectorsController < ApplicationController
  def page_view
    site_uid = params[:sid]
    # Check SID exists
    # unless Site.exists?(uid: site_sid)
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

    pv = PageView.new id: SecureRandom.uuid, site_uid: site_uid, host: host, path: path # TODO: referrer and more.
    pv.send :create_or_update

    head :no_content
  end
end
