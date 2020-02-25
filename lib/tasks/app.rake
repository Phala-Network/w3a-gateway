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

      gap = ((current_time - start_time) / 60).to_i
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
          next if aggregators.empty?

          aggregators.each { |agg| agg.collect pv }
        end
        start_time = end_time
        grouped_aggregators.values.flatten.map(&:rotate!)

        kv = KeyValue.find_or_create_by(key: "last_processed_online_users_timestamp", value_type: :datetime)
        kv.value = end_time
        kv.save!
      end
    end
  end
end
