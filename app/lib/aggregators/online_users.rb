# frozen_string_literal: true

module Aggregators
  class OnlineUsers < Aggregator
    attr_reader :unique_cids, :unique_ips, :last_pv_timestamp

    def initialize(site)
      super

      @unique_cids = Set.new
      @unique_ips = Set.new
      @last_pv_timestamp = nil
    end

    def collect(page_view)
      @unique_cids << page_view.cid
      @unique_ips << page_view.ip
      @last_pv_timestamp = page_view.created_at
    end

    def rotate!
      unless @last_pv_timestamp
        return
      end

      site.online_users_reports.create!(
        unique_cid_count: unique_cids.size,
        unique_ip_count: unique_ips.size,
        timestamp: last_pv_timestamp.beginning_of_minute
      )
    end
  end
end
