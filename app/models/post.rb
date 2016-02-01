class Post < ActiveRecord::Base

  belongs_to :group
  has_many :tags, :through => :post_tags
  has_many :post_tags

  validates :content, presence: true
  validates :title, presence: true

  def add_tag(tag)
  	find_tag = Tag.find_by(name: tag)
  	unless find_tag.nil?
  		self.post_tags.create(post_id: self.id, tag_id: find_tag.id)
		else 
			new_tag = Tag.create(name: tag)
			self.post_tags.create(post_id: self.id, tag_id: new_tag.id)
		end
	end

end