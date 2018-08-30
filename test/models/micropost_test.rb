require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  #
  def setup
    @user = users(:michael)
    # 13.12 Micopost.newをuserに関連付けた投稿として、このように書き換え可能
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  # 全てのmicropostはuser_idを持っているはず
  # user_idがnilではないかどうか
  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  # content バリデーションに対するテスト 空投稿×
  test "content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  # 140文字まで
  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  # 新しい投稿が上に来るようにしたい
  # DBで最初に来る投稿が、fixuture内の投稿more_recentと同じかどうか
  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
