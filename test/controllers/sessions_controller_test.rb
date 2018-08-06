require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    # get sessions_new_urlを以下に変更。名前付き(_path)ルートを使うテスト
    get login_path
    assert_response :success
  end

end
