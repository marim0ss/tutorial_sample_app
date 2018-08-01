class User < ApplicationRecord

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
end
