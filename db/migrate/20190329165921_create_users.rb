# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :public_key, null: false, index: { unique: true }

      t.datetime :disabled_at
      t.datetime :activated_at

      t.timestamps null: false
    end
  end
end
