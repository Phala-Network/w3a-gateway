# frozen_string_literal: true

namespace :app do
  namespace :aggregate do
    desc "Aggregate online users"
    task online_users: :environment do
      sites = Site.all # .verified

      last_processed_ts =
        KeyValue.find_by(key: "last_processed_online_users_timestamp")&.value
      last_processed_ts ||= PageView.order(created_at: :asc).first&.created_at
      unless last_processed_ts
        next
      end

      start_time = last_processed_ts.beginning_of_minute
      current_time = Time.zone.now.beginning_of_minute

      gap = ((current_time.to_i - start_time.to_i) / 60).to_i
      gap.times do
        grouped_aggregators =
          sites.map do |site|
            {
              site.sid => [
                Aggregators::OnlineUsers.new(site),
              ]
            }
          end.reduce(&:merge)

        end_time = start_time + 1.minute
        PageView.order(created_at: :asc).where(created_at: start_time..end_time).each do |pv|
          aggregators = grouped_aggregators[pv.sid]
          next if aggregators&.empty?

          aggregators.each { |agg| agg.collect pv }
        end
        start_time = end_time
        grouped_aggregators.values.flatten.map(&:rotate!)

        kv = KeyValue.find_or_create_by(key: "last_processed_online_users_timestamp", value_type: :datetime)
        kv.value = end_time
        kv.save!
      end
    end

    desc "Aggregate hourly stats"
    task hourly_stats: :environment do
      sites = Site.all # .verified

      last_processed_ts =
        KeyValue.find_by(key: "last_processed_hourly_stats_timestamp")&.value
      last_processed_ts ||= PageView.order(created_at: :asc).first&.created_at
      unless last_processed_ts
        next
      end

      start_time = last_processed_ts.beginning_of_minute
      current_time = Time.zone.now.beginning_of_minute

      gap = ((current_time.to_i - start_time.to_i) / (60 * 60)).to_i
      gap.times do
        grouped_aggregators =
          sites.map do |site|
            {
              site.sid => [
                Aggregators::HourlyStats.new(site),
              ]
            }
          end.reduce(&:merge)

        end_time = start_time + 1.hour
        PageView.order(created_at: :asc).where(created_at: start_time..end_time).each do |pv|
          aggregators = grouped_aggregators[pv.sid]
          next if aggregators.empty?

          aggregators.each { |agg| agg.collect pv }
        end
        start_time = end_time
        grouped_aggregators.values.flatten.map(&:rotate!)

        kv = KeyValue.find_or_create_by(key: "last_processed_hourly_stats_timestamp", value_type: :datetime)
        kv.value = end_time
        kv.save!
      end
    end

    desc "Aggregate daily stats"
    task daily_stats: :environment do
      sites = Site.all # .verified
      sites.find_each do |site|
        last_processed_date = site.daily_stats_reports.order(date: :desc).first&.date
        last_processed_date ||= site.hourly_stats_reports.order(date: :asc).first&.date&.yesterday
        next unless last_processed_date
        next if last_processed_date == Date.today.yesterday

        site
          .hourly_stats_reports
          .where("date > ? AND date < ?", last_processed_date, Date.today)
          .group_by(&:date)
          .each do |date, reports|
          site.daily_stats_reports.create! date: date,
                                           pv_count: reports.map(&:pv_count).reduce(&:+),
                                           clients_count: reports.map(&:clients_count).reduce(&:+),
                                           avg_duration_in_seconds: reports.map(&:avg_duration_in_seconds).reduce(&:+)
        end
      end
    end
  end
end
