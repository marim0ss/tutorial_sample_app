class User < ApplicationRecord
  attr_accessor :remember_token
  # before_save  保存直前に実行されるメソッド
    #これで、データベースに保存される直前にemailの文字列は全て小文字変換される
  before_save { self.email = email.downcase }

  validates :name,  presence: true, length: {maximum: 50 }

    #正規表現で有効なemailを指定する このパターンに一致するemailだけが有効になる
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
                          # case_sensitiveにfalseを指定すると、大文字小文字を差を無視する
  # パスワード
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  # 渡された文字列のハッシュ値を返す
  # fixture向けのdigestメソッドを追加する
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64    #ランダムな文字列を生成
  end
  # 永続セッションのためにユーザーをDBに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?    #returnでメソッド終了させてる
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)     #記憶ダイジェストを更新している
  end
end
