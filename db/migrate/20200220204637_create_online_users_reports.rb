class CreateOnlineUsersReports < ActiveRecord::Migration[6.0]
  def change
    create_table :online_users_reports do |t|
      t.references :site, foreign_key: false

      t.integer :unique_cid_count, null: false
      t.integer :unique_ip_count, null: false

      t.integer :week_on_week, default: 0
      t.integer :day_to_day, default: 0

      t.datetime :timestamp, null: false
      t.date :date, null: false

      t.timestamps
    end
  end
end
