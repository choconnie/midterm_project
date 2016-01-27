class AddComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :post, index: true
      t.string :content
      t.timestamps null: true
    end
  end
end
