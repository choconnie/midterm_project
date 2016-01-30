class Post < ActiveRecord::Base

  belongs_to :group
  has_and_belongs_to_many :tags

  validates :content, presence: true
  validates :title, presence: true

end