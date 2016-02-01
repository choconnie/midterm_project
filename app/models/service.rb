class Service < ActiveRecord::Base

  validates :title, presence: true, length: { maximum: 30 }
  validates :email, uniqueness: true, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  #validates :phone, presence: true, format: { with: /\d{3}-\d{3}-\d{4}/ }
  validates :content, presence: true
  has_many :tags, :through => :service_tags
  has_many :service_tags

	def add_tag(tag)
  	find_tag = Tag.find_by(name: tag)
  	unless find_tag.nil?
  		self.service_tags.create(service_id: self.id, tag_id: find_tag.id)
		else 
			new_tag = Tag.create(name: tag)
			self.service_tags.create(service_id: self.id, tag_id: new_tag.id)
		end
	end

end