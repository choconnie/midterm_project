class AddTagsTable < ActiveRecord::Migration
  def change
  	create_table :tags do |t|
  		t.string	:name
  	end

  	create_table :post_tags, id: false do |t|
      t.belongs_to :tag
      t.belongs_to :post
    end
  end
end
