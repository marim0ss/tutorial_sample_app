module SessionsHelper
  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  # 現在ログイン中のユーザーを返す(いる場合)
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
    # @current_user = @current_user || User.find_by(id: session[:user_id])と同じ意味
  end
  # ユーザーがログインしていればtrue、その他ならfalseを返す.
    # !:否定演算子     !current_user.nil? :「current_userがnilではない」がtrue
  def logged_in?
    !current_user.nil?
  end

  # 現在のユーザーをログアウトする
 def log_out
   session.delete(:user_id)
   @current_user = nil
 end
end
