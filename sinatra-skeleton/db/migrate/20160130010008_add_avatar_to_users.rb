class AddAvatarToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :avatar_name, :string, default: "avatar.png"
  end
end
