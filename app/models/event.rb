class Event < ActiveRecord::Base

  validates :title, presence: true, length: { maximum: 30 }
  validates :event_date, presence: true
  validates :url, presence: true
  validates :location, presence: true

end