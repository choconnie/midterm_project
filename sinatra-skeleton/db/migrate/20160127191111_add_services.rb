class AddServices < ActiveRecord::Migration
  def change
    create_table :servicies do |t|
      t.string :title
      t.string :content
      t.string :email
      t.string :phone
      t.timestamps null: true
    end
  end
end
