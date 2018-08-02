require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

    # assert_no_differenceのブロックを実行する前後で引数の値(User.count)が変わらないことを検証してる
    # => ユーザー数を覚えた後にデータを投稿して、ユーザー数が河原井かどうかを検証している
    test "valid signup information" do
      get signup_path
      assert_difference 'User.count', 1 do
        post users_path, params: { user: { name:  "Example User",
                                           email: "user@example.com",
                                           password:              "password",
                                           password_confirmation: "password" } }
      end

      # follow_redirect: Postリクエスト送信結果を見て、指定されたリダイレクト先に移動するメソッド。
      follow_redirect!
      #  登録成功後にどのテンプレートが表示されるかのテスト。
      # => showページに関するほぼ全てのエラーが出ないかを検証している
      assert_template 'users/show'
    end
end
