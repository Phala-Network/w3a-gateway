class CreateWeeklyClients < ActiveRecord::Migration[6.0]
  def change
    create_table :weekly_clients do |t|
      t.references :site, null: false, foreign_key: false
      t.string :cid
      t.date :date
      t.index %i[site_id cid date], unique: true

      t.datetime :created_at
    end
  end
end
