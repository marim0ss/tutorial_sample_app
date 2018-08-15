require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

 # 編集の失敗に対するテスト ======================================================
  test "unsuccessful edit" do
    log_in_as(@user)            # before_actionしているので、ログインしている状態でテストする
    get edit_user_path(@user)       #editページにアクセスし
    assert_template 'users/edit'     # viewが表示されるかどうか

    # 無効な情報を送ってみて.....(patchを使用する)
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }
    # viewが再表示されるかどうか
    assert_template 'users/edit'
    # divタグでalertクラスが１あるかどうか
    assert_select "div.alert", count: 1
  end

  # 編集の成功に対するテスト=========================================================
  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end

  # ログイン後、editページなど本来ユーザーが表示したかったぺージを表示させる =================================
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)   # ます編集ページにアクセスし
    log_in_as(@user)            #ログインした後に
    assert_redirected_to edit_user_url(@user)      #デフォのプロフィールページではなく、編集ページにリダイレクトしているか
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
end
