class User < ApplicationRecord
  attr_accessor :remember_token

  before_create on: :create  do
    self.email += "@st.kyoto-u.ac.jp"
  end

  before_save do
    self.email = email.downcase
  end

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true,
            length: { maximum: 50 }
  validates :email, presence: true,
            uniqueness: { case_sensitive: false },
            #format: { with: VALID_EMAIL_REGEX },
            length: { maximum: 255 }
  validates :terms, presence: true
  validates :temp_terms, acceptance: true

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
               BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = SecureRandom.urlsafe_base64 #ランダムなトークン
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end
end
