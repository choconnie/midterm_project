class AddPosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :group, index: true
      t.string :title
      t.string :content
      t.timestamps null: true
    end
  end
end
