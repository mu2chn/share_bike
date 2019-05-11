class Tourist < ApplicationRecord
  has_many :tourist_bikes

  before_save do
    self.email = email.downcase
  end
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true,
            length: { maximum: 50 }
  validates :email, presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: VALID_EMAIL_REGEX },
            length: { maximum: 255 }
  validates :terms, presence: true

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
end
