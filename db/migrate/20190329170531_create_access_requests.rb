# frozen_string_literal: true

class CreateAccessRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :access_requests do |t|
      t.references :user, foreign_key: true, null: false

      t.string :request_token, null: false, index: { unique: true }
      t.datetime :expires_at
      t.datetime :granted_at

      t.timestamps null: false
    end
  end
end
