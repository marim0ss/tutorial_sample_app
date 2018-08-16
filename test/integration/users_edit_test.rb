require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

 # 編集の失敗に対するテスト ======================================================
  test "unsuccessful edit" do
    log_in_as(@user)          # before_actionしているので、ログインしている状態でテストする
    get edit_user_path(@user)       #editページにアクセスし
    assert_template 'users/edit'     # viewが表示されるかどうか

    # 無効な情報を送ってみて.....(patchを使用する)
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }
    assert_template 'users/edit'         # viewが再表示されるかどうか
    assert_select "div.alert", count: 1      # divタグでalertクラスが１あるかどうか
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

  # 10.29ログイン後、editページなど本来ユーザーが表示したかったぺージを表示させる =================================
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)   # ます編集ページにアクセスしようとする(未ログイン状態で弾かれる)
    log_in_as(@user)            #ログインした後に
    assert_redirected_to edit_user_url(@user)    #デフォのプロフィールページではなく、編集ページにリダイレクトさせるはず
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
