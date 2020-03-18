class AddColumnsToSites < ActiveRecord::Migration[6.0]
  def change
    change_table :sites do |t|
      t.string :name
      t.string :description
      t.string :phala_address
    end
  end
end
