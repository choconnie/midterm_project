class AddUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.references :group, index: true
      t.string :username
      t.string :password
      t.string :email
      t.boolean :status, default: true
      t.timestamps null: true
    end
  end
end
