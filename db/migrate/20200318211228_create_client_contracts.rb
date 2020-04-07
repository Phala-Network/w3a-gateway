class CreateClientContracts < ActiveRecord::Migration[6.0]
  def change
    create_table :client_contracts do |t|
      t.references :contract, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
