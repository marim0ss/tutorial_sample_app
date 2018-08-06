class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  # ↑セッション実装するのにappliationコントローラにSessionヘルパーモジュールを読み込む
end
