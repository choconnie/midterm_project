class Membership < ActiveRecord::Base
	
	belongs_to :user
	belongs_to :group
  has_many   :posts

  validates :user_id, presence: true
  validates :group_id, presence: true

end