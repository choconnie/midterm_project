class Group < ActiveRecord::Base

  has_and_belongs_to_many :users
  has_many :posts

  validates :group_name, presence: true
  validates :city, presence: true

end