class User < ApplicationRecord
  attr_accessor :remember_token
  before_save { email.downcase! }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                  format: { with: VALID_EMAIL_REGEX },
                  uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  class << self
    # 渡された文字列のハッシュ値を返す:BCryptによって長さ60の文字列
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ?BCrypt::Engine::MIN_COST:
                                                  BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # ランダムなトークンを返す:base64によって長さ22の文字列
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # 永続セッションのためにユーザーをデータベースに記憶する:remember_tokenとremember_digestを作る
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す,ない場合はfalseを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄する:remember_digestを消す
  def forget
    update_attribute(:remember_digest, nil)
  end
end
