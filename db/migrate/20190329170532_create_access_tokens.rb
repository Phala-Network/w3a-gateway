# frozen_string_literal: true

class CreateAccessTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :access_tokens do |t|
      t.references :user, foreign_key: true, null: false
      t.references :access_request, foreign_key: false

      t.string :token, null: false, index: { unique: true }
      t.string :refresh_token, null: false, index: { unique: true }
      t.datetime :expires_at
      t.datetime :revoked_at

      t.timestamps null: false
    end
  end
end
