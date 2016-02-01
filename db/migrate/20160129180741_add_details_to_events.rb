class AddDetailsToEvents < ActiveRecord::Migration
  def change
  	add_column :events, :details, :string
  end
end
