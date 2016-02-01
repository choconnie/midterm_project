class AddUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_digest
      t.string :email
      t.boolean :status, default: true
      t.timestamps null: true
    end
  end
end
