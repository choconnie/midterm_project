class Post < ActiveRecord::Base

  belongs_to :group
  has_many :tags, :through => :post_tags
  has_many :post_tags

  validates :content, presence: true
  validates :title, presence: true

  def add_tag(tag)
  	tag = Tag.find_by(name: tag)
  	self.post_tags.create(post_id: self.id, tag_id: tag.id)
	end

end