class CreateTotalStatsReports < ActiveRecord::Migration[6.0]
  def change
    create_table :total_stats_reports do |t|
      t.references :site, null: false, foreign_key: false

      t.integer :clients_count, null: false
      t.integer :pv_count, null: false
      t.integer :avg_duration_in_seconds, null: false

      t.datetime :timestamp, null: false

      t.timestamps
    end
  end
end
