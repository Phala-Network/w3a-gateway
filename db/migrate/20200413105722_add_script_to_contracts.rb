class AddScriptToContracts < ActiveRecord::Migration[6.0]
  def change
    change_table :contracts do |t|
      t.text :script, default: ""
    end
  end
end
