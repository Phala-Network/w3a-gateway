class CreateSites < ActiveRecord::Migration[6.0]
  def change
    create_table :sites do |t|
      t.references :creator, foreign_key: { to_table: "users" }
      t.string :domain, null: false
      t.string :sid, null: false, index: { unique: true }

      t.boolean :verified, null: false, default: false

      t.timestamps
    end
  end
end
