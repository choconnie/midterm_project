class AddImgprofile < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :description
      t.string :content_type
      t.string :filename
      t.binary :binary_data
    end
  end
end