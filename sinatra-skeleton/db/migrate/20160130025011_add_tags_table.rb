class AddTagsTable < ActiveRecord::Migration
  def change
  	create_table :tags do |t|
  		t.string	:name
  	end

  	create_table :posts_tags, id: false do |t|
      t.belongs_to :tag, index: true
      t.belongs_to :post, index: true
    end
  end
end
