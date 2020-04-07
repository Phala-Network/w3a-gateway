class CreateContracts < ActiveRecord::Migration[6.0]
  def change
    create_table :contracts do |t|
      t.string :name
      t.string :description
      t.string :agreement
      t.boolean :builtin, default: false
      t.references :group, null: false, foreign_key: { to_table: :contract_groups }

      t.timestamps
    end
  end
end
