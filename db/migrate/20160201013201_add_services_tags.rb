class AddServicesTags < ActiveRecord::Migration
  def change
  	create_table :service_tags, id: false do |t|
      t.belongs_to :tag
      t.belongs_to :service
    end
  end
end
