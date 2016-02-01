class Photo < ActiveRecord::Base 

  belongs_to :user

  def image_file=(input_data)
    self.filename = input_data.original_filename
    self.content_type = input_data.content_type.chomp
    self.url = input_data.read
  end
end