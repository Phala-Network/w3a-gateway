class CreateSiteClients < ActiveRecord::Migration[6.0]
  def change
    create_table :site_clients do |t|
      t.references :site, null: false, foreign_key: false
      t.string :cid
      t.index %i[site_id cid], unique: true

      t.datetime :created_at
    end
  end
end
