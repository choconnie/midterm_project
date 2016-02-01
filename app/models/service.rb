class Service < ActiveRecord::Base

  validates :title, presence: true, length: { maximum: 30 }
  validates :email, uniqueness: true, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  #validates :phone, presence: true, format: { with: /\d{3}-\d{3}-\d{4}/ }
  validates :content, presence: true
  has_many :tags, :through => :service_tags
  has_many :service_tags
end