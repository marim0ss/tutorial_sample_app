require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

#テスト結果をRED，GREENで表示する設定のコード。Minitest-reporters gemを利用している
require "minitest/reporters"
Minitest::Reporters.use!



class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  # テストユーザーがログイン中の場合にtrueを返す
  def is_logged_in?
    !session[:user_id].nil?
  end

 # 5.35 test環境でもApplication Helperを使えるようにする
  include ApplicationHelper

  # Add more helper methods to be used by all tests here...
end
