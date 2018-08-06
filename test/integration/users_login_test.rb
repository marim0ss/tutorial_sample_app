require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
 #fixture 有効な情報を使ってユーザーログインテストをする
  def setup
    @user = users(:michael)
  end
  # フラッシュメッセージが更新などした後も残る現象、発生しないのテスト
  # test "login with invalid information" do
  #   get login_path
  #   assert_template 'sessions/new'
  #   post login_path, params: { session: { email: "", password: "" } }
  #   assert_template 'sessions/new'
  #   assert_not flash.empty?
  #   get root_path
  #   assert flash.empty?
  # end
  test "login with valid information" do
     get login_path
     post login_path, params: { session: { email:    @user.email,
                                           password: 'password' } }
    # リダイレクト先が正しいかどうか
     assert_redirected_to @user
    # 実際のページに移動できるかどうか
     follow_redirect!
     assert_template 'users/show'
    # count 0   渡したパターンに一致するリンクが０かどうかを確認
     assert_select "a[href=?]", login_path, count: 0
     assert_select "a[href=?]", logout_path
     assert_select "a[href=?]", user_path(@user)
   end
   # ユーザー ログアウトのテスト
   test "login with valid information followed by logout" do
     get login_path
     post login_path, params: { session: { email:    @user.email,
                                           password: 'password' } }
     assert is_logged_in?
     assert_redirected_to @user
     follow_redirect!
     assert_template 'users/show'
     assert_select "a[href=?]", login_path, count: 0
     assert_select "a[href=?]", logout_path
     assert_select "a[href=?]", user_path(@user)
     delete logout_path
     assert_not is_logged_in?
     assert_redirected_to root_url
     follow_redirect!
     assert_select "a[href=?]", login_path
     assert_select "a[href=?]", logout_path,      count: 0
     assert_select "a[href=?]", user_path(@user), count: 0
   end
end
