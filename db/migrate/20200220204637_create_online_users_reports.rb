class CreateOnlineUsersReports < ActiveRecord::Migration[6.0]
  def change
    create_table :online_users_reports do |t|
      t.references :site, foreign_key: false

      t.integer :unique_cid_count, null: false
      t.integer :unique_ip_count, null: false

      t.datetime :timestamp, null: false

      t.timestamps
    end
  end
end
