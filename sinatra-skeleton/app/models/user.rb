class User < ActiveRecord::Base

  has_and_belongs_to_many :groups

  validates :username, presence: true
  validates :password, length: { minimum: 6 }
  validates :email, presence: true

end