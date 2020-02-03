class CreatePageViews < ActiveRecord::Migration[6.0]
  def change
    create_table :page_views, id: :string do |t|
      t.string :site_uid, null: false
      t.string :host, null: false
      t.string :path, null: false
      t.string :referrer

      t.string :client_uid

      t.boolean :analysed, null: false, default: false

      t.datetime :created_at
    end
  end
end
