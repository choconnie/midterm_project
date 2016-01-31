class Group < ActiveRecord::Base

  has_many :users, :through => :memberships
  has_many :memberships
  has_many :posts

  validates :group_name, presence: true
  validates :city, presence: true

end