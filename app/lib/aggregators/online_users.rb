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

      timestamp = last_pv_timestamp.beginning_of_minute

      last_week = site.online_users_reports.find_by timestamp: (timestamp - 1.week)
      yesterday = site.online_users_reports.find_by timestamp: (timestamp - 1.day)

      site.online_users_reports.create!(
        unique_cid_count: unique_cids.size,
        unique_ip_count: unique_ips.size,
        week_on_week: last_week ? (unique_cids.size - last_week.unique_cid_count) / last_week.unique_cid_count : 0,
        day_to_day: yesterday ? (unique_cids.size - yesterday.unique_cid_count) / yesterday.unique_cid_count : 0,
        timestamp: last_pv_timestamp.beginning_of_minute,
        date: last_pv_timestamp.to_date
      )
      unless site.verified?
        site.update! verified: true
      end
    end
  end
end
