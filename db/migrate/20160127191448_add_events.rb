class AddEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :post, index: true
      t.string :title
      t.string :event_date
      t.string :location
      t.string :url
      t.timestamps null: true
    end
  end
end
