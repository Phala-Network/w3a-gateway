class CreateKeyValues < ActiveRecord::Migration[6.0]
  def change
    create_table :key_values do |t|
      t.string :key, null: false, index: { unique: true }
      t.integer :value_type, null: false
      t.integer :integer_value
      t.datetime :datetime_value
      t.string :string_value

      t.timestamps
    end
  end
end
