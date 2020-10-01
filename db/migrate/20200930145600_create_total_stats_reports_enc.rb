class CreateTotalStatsReportsEnc < ActiveRecord::Migration[6.0]
  def change
    create_table :total_stats_reports_enc do |t|
      t.references :site, null: false, foreign_key: false

      t.string :clients_count, null: false
      t.string :pv_count, null: false
      t.string :avg_duration_in_seconds, null: false

      t.datetime :timestamp, null: false

      t.timestamps
    end
  end
end