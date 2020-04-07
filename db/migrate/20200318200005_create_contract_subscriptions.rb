class CreateContractSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :contract_subscriptions do |t|
      t.references :contract, null: false, foreign_key: true
      t.references :site, null: false, foreign_key: true
      t.string :status

      t.index %i[contract_id site_id], unique: true

      t.timestamps
    end
  end
end
