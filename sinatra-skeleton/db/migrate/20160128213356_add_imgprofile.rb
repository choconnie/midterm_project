class AddImgprofile < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :description
      t.string :content_type
      t.string :filename
      t.string :url
    end
  end
end