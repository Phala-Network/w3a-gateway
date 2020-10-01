class AddColumnToPageViews < ActiveRecord::Migration[6.0]
  def change
    change_table :page_views do |t|
      t.string :uid
    end
  end
end
