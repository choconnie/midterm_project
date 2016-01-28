class AddGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :group_name
      t.string :city
      t.timestamps null: true
    end
  end
end
