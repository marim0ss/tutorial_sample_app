require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  # 10.34 ndexアクションが正しくリダイレクトされるかのテスト =========================
    # indexページはログインしているユーザーにしか見えないようにする
  test "should redirect index when not logged in" do
    get users_path       #ログインなしでindexページにアクセスリクエストを送ると
    assert_redirected_to login_url        # loginページへリダイレクトされるはず
  end

  # 10.20  edit, updateアクションの保護に関するテスト===============================
  test "should redirect edit when not logged in" do
    get edit_user_path(@user)     #ログインなしでeditをGETリクエスト送ると
    assert_not flash.empty?       #flash変数にメッセージが代入されるはず（空ではないはず）
    assert_redirected_to login_url  #loginページにリダイレクトされるはず
  end

  test "should redirect update when not logged in" do
    # patchを指定することでupdateアクションを動かしている. ログインなしでupdateアクションを動かすと、
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end


  # 10.24間違ったユーザーが編集しようとした時のテスト ==========================================
  # すでにログインしているユーザーが対象なので、root_urlにリダイレクトしている
  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)        #@other_user(archer)としてログインしていて
    get edit_user_path(@user)     # @user(michael)のeditアクションを動かそうとした時
    assert flash.empty?           # flashは働かせないようにしているはず
    assert_redirected_to  root_url        # TOPページにリダイレクトするはず
  end


    # updateも同様
  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  # 10.61削除機能のテスト(管理者権限の制御をアクションレベルでテストする)======
    # 1.ログインしていないユーザーなら、ログイン画面にリダイレクトされること
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do       #ユーザー数が変化していないはず。
      delete user_path(@user)                #  ログインしてない状態で@userにDELETEが発行される時
    end
    assert_redirected_to login_url           #login画面にリダイレクトされるはず
  end

  # 2.ログイン済みでも管理者でない場合はHome画面にリダイレクトされること==========
  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)                  # = ログイン済みユーザー
    assert_no_difference 'User.count' do       # ユーザー数は変わらないはず
      delete user_path(@user)                # @userのdeleteリクエストしようとしたら
    end
    assert_redirected_to root_url
  end
end
