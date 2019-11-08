class User < ApplicationRecord
  attr_accessor :remember_token

  before_validation do
    # if !self.email.match(VALID_EMAIL_REGEX)
    #   self.email += "@st.kyoto-u.ac.jp"
    # end
  end

  before_save do
    self.email = email.downcase
  end

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  KYODAY_EMAIL = /\A[\w+\-.]+@st.kyoto-u.ac.jp/i

  validates :name, presence: true,
            length: {maximum: 50}
  validates :email, presence: true,
            format: { with: KYODAY_EMAIL },
            length: {maximum: 255}
  validates :email, uniqueness: {case_sensitive: false}, on: :create
  validates :terms, presence: true
  validates :temp_terms, acceptance: true

  has_secure_password
  validates :password, presence: true, length: {minimum: 6}

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
