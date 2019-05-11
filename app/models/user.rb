class User < ApplicationRecord
  before_save do
    self.email = email.downcase
    self.email += "@st.kyoto-u.ac.jp"
  end

  validates :name, presence: true
  validates :email, presence: true,
            uniqueness: { case_sensitive: false }
  validates :terms, presence: true

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
end
