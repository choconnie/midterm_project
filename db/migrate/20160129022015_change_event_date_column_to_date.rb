class ChangeEventDateColumnToDate < ActiveRecord::Migration
  def change
  	change_column :events, :event_date, :datetime
  end
end
