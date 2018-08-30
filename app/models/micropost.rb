class Micropost < ApplicationRecord
  belongs_to :user

  # default_scope...DBから要素を取得したときの順番を指定するメソッド
  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
