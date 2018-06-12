require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

 # レイアウトのリンクに対するテスト。各リンクが正しく動いているか
  test "layout links" do
      get root_path
      assert_template 'static_pages/home'
      # 特定のリンクが存在するかどうかのチェック
      assert_select "a[href=?]", root_path, count: 2
      assert_select "a[href=?]", help_path
      assert_select "a[href=?]", about_path
      assert_select "a[href=?]", contact_path

# 5.36 test環境でfull_titleヘルパーを使う
      get signup_path
      assert_select "title", full_title("Sign up")
    end
end
