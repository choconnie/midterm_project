class Service < ActiveRecord::Base

  validates :title, presence: true, length: { maximum: 30 }
  validates :name, presence: true, length: { maximum: 40 }
  validates :email, uniqueness: true, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  validates :phone, presence: true, format: { with: /\d{3}-\d{3}-\d{4}/ }
  validates :content, presence: true

end