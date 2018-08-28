require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
  get signup_path
  assert_no_difference 'User.count' do
    post users_path, params: { user: { name:  "",
                                       email: "user@invalid",
                                       password:              "foo",
                                       password_confirmation: "bar" } }
      end
      assert_template 'users/new'
      assert_select 'div#error_explanation'
      assert_select 'div.field_with_errors'
    end

  # assert_no_differenceのブロックを実行する前後で引数の値(User.count)が変わらないことを検証してる
  # => ユーザー数を覚えた後にデータを投稿して、ユーザー数が河原井かどうかを検証している
  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end

    assert_equal 1, ActionMailer::Base.deliveries.size  # 配信されたメールが１通かどうか
    user = assigns(:user)
    assert_not user.activated?
    # 有効化していない状態でログインしてみる
    log_in_as(user)
    assert_not is_logged_in?
    # 有効化トークンが不正な場合
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # トークンは正しいがメールアドレスが無効な場合
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # 有効化トークンが正しい場合
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    # follow_redirect: Postリクエスト送信結果を見て、指定されたリダイレクト先に移動するメソッド。
    follow_redirect!
    #  登録成功後にどのテンプレートが表示されるかのテスト。
    # => showページに関するほぼ全てのエラーが出ないかを検証している
    assert_template 'users/show'

    # ユーザー登録が終わったユーザーがログインできているかのテスト
    assert is_logged_in?
  end
end
