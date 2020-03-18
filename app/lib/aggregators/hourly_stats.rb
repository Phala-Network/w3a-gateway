# frozen_string_literal: true

module Aggregators
  class HourlyStats < Aggregator
    attr_reader :pv_count, :unique_cids, :cid_pv, :last_pv_timestamp, :pv, :devices

    def initialize(site)
      super

      @pv_count = 0
      @unique_cids = Set.new
      @cid_pv = {}
      @last_pv_timestamp = nil
      @pv = {}
      @devices = {}
    end

    def collect(page_view)
      @pv_count += 1
      @unique_cids << page_view.cid
      @last_pv_timestamp = page_view.created_at
      @cid_pv[page_view.cid] ||= []
      @cid_pv[page_view.cid] << page_view.created_at
      @pv[page_view.path] ||= 0
      @pv[page_view.path] += 1
      browser = Browser.new(page_view.ua)
      @devices[browser.name] ||= 0
      @devices[browser.name] += 1
    end

    def rotate!
      unless @last_pv_timestamp
        return
      end

      SiteClient.insert_all(unique_cids.map { |cid| { site_id: site.id, cid: cid, created_at: last_pv_timestamp } })
      WeeklyClient.insert_all(unique_cids.map { |cid| { site_id: site.id, cid: cid, date: last_pv_timestamp.to_date.beginning_of_week, created_at: Time.zone.now } })
      Client.insert_all(unique_cids.map { |cid| { fingerprint: cid, created_at: Time.zone.now, updated_at: Time.zone.now } })

      devices.each do |device, count|
        stats = WeeklyDevice.find_or_initialize_by(site_id: site.id, device: device, date: last_pv_timestamp.to_date.beginning_of_week)
        if stats.new_record?
          stats.count = count
          stats.save!
        else
          stats.increment :count, count
        end
      end

      total_avg =
        if @cid_pv.keys.any?
          @cid_pv.values.map do |v|
            new_arr = v.each_cons(2).map { |a, b| b - a }
            size = new_arr.size
            size > 1 ? new_arr.reduce(&:+) / size : 60 # If only one view, assume it 1 min
          end.reduce(&:+) / @cid_pv.keys.size
        else
          0
        end

      timestamp = last_pv_timestamp.beginning_of_hour + 1.hour
      report = site.total_stats_reports.new
      report.pv_count = site.total_stats_reports.order(created_at: :desc).first&.pv_count || 0
      report.pv_count += pv_count
      report.clients_count = site.clients.size
      if total_avg > 0
        report.avg_duration_in_seconds = total_avg
        report.avg_duration_in_seconds /= 2.0
        report.avg_duration_in_seconds = report.avg_duration_in_seconds.ceil
      else
        report.avg_duration_in_seconds = total_avg.ceil
      end
      report.timestamp = timestamp
      report.save!

      report = site.hourly_stats_reports.new
      report.pv_count = pv_count
      report.clients_count = unique_cids.size
      report.avg_duration_in_seconds = total_avg
      report.timestamp = timestamp
      report.date = timestamp.to_date
      report.save!

      pv.each do |k, v|
        week = timestamp.to_date.beginning_of_week
        site.weekly_sites_reports.find_or_create_by(date: week, site: site, path: k).increment! :count, v
      end
    end
  end
end
