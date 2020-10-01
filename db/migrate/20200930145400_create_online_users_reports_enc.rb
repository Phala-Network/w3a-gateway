class CreateOnlineUsersReportsEnc < ActiveRecord::Migration[6.0]
  def change
    create_table :online_users_reports_enc do |t|
      t.references :site, foreign_key: false

      t.string :unique_cid_count, null: false
      t.string :unique_ip_count, null: false

      t.string :week_on_week, default: 0
      t.string :day_to_day, default: 0

      t.datetime :timestamp, null: false
      t.date :date, null: false

      t.timestamps
    end
  end
end
