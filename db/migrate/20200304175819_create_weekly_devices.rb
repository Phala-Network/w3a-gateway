class CreateWeeklyDevices < ActiveRecord::Migration[6.0]
  def change
    create_table :weekly_devices do |t|
      t.references :site, null: false, foreign_key: true
      t.string :device
      t.integer :count
      t.date :date
      t.index %i[site_id device date], unique: true

      t.timestamps
    end
  end
end
