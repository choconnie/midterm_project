class User < ActiveRecord::Base

  has_secure_password

  has_many :groups, :through => :memberships
  has_many :memberships

  validates :username, presence: true
  validates :password, length: { minimum: 6 }
  validates :email, presence: true

  def status_check
  	errors.add(:status, ": Your account has been deactivated. Please contact a site administrator") unless (self.status == true)
  end

  def password_check(pw)
  	errors.add(:password, ": Your password is incorrect. Please try again.") unless (self.password == pw)
  end
end