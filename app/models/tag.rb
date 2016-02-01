class Tag < ActiveRecord::Base

	has_many :posts, :through => :post_tags
  has_many :post_tags
  has_many :services, :through => :service_tags
  has_many :service_tags

  validates :name, 
  	presence: true

end