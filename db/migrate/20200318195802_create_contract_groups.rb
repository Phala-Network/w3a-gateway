class CreateContractGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :contract_groups do |t|
      t.string :name

      t.timestamps
    end
  end
end
