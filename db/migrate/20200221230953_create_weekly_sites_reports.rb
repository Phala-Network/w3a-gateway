class CreateWeeklySitesReports < ActiveRecord::Migration[6.0]
  def change
    create_table :weekly_sites_reports do |t|
      t.references :site, null: false, foreign_key: false

      t.string :path, null: false
      t.integer :count, null: false, default: 0

      t.date :date, null: false

      t.timestamps
    end
  end
end
