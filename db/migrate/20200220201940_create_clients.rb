class CreateClients < ActiveRecord::Migration[6.0]
  def change
    create_table :clients do |t|
      t.string :fingerprint, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
