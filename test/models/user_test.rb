require 'test_helper'

class UserTest < ActiveSupport::TestCase

# 有効なUserかどうかをテストする
  # setupメソッド内で、まず有効なUserオブジェクト(@user)を作成する
  #setup内の処理は、各テストが走る直前に実行される
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                      password: "foobar", password_confirmation: "foobar")
                      # パスワードとパスワード確認の値をセット
  end

# ここで@userが有効かどうかをテストしている
  # assertメソッド：@userがtrueを返すと成功し、falseを返すと失敗する
  test "should be valid" do
    assert @user.valid?
  end

# name属性があるかどうかのテスト
  # @user.name=""  まず@user変数のname属性にから文字をセット
  # assert_notメソッドで@userが有効ではなくなったことを確認している
  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end

# emailについてもあるかどうかのテスト
  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end

# 文字数制限のテスト
  test "name should not be too long" do
     @user.name = "a" * 51       #51文字の文字列を作るために掛け算を書いてみる
     assert_not @user.valid?     #これは有効でないことを確認
   end

   test "email should not be too long" do
     @user.email = "a" * 244 + "@example.com" #これも同じくa*244でemailが255文字オーバーするようにしてみる
     assert_not @user.valid?     #これは有効でないことを確認
   end

#有効なアドレス、無効なアドレス
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
    # ↑assertメソッドの第二引数にエラーメッセージを追加
      # これによって、どのアドレスで失敗したかを特定できるようにしている
      #inspectメソッド：p ~ と同じ。文字列を返す

  # 重複するアドレスは拒否するテスト
    #dup : 同じ属性を持つデータを複製するメソッド
    # .saveした後になのでdupで複製したduplicate_userは無効のはず
  test "email addresses should be unique" do
    duplicate_user = @user.dup

    # 通常大文字・小文字は区別されないので、アドレスを大文字でも同じものとする
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end


  #パスワードが空出ないこと・最小６文字の検証
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

 #ダイジェストが存在しない場合のauthenticated?のテスト
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end
end
