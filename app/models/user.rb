class User < ApplicationRecord
  before_save { self.email = email.downcase }

  validates :name, presence: true
  validates :email, presence: true,
            uniqueness: { case_sensitive: false }
  validates :terms

  has_secure_password
end
