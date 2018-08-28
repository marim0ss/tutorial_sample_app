class SessionsController < ApplicationController

# ログイン機能担当。

# ログインフォームをnewで処理
  def new
  end

  # createにPOST送信するとログインする
  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if user && user.authenticate(params[:session][:password])    # authenticate..認証に失敗した時にfalseを返すメソッド
=begin
      log_in user         # app/helper/sessions_helper.rbで定義したメソッド

      # if文と同等↓  @remember_meチェックボックスがONなら記憶、OFFなら忘れる。"remember user"としていたのを書き換え
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user    #フレンドリーフォワーディングを備えたリダイレクト
=end
      # 11.32 有効でないユーザーがログインすることのないように書き換え
        if user.activated?
          log_in user
          params[:session][:remember_me] == '1' ? remember(user) : forget(user)
          redirect_back_or user
        else
          message  = "Account not activated. "
          message += "Check your email for the activation link."
          flash[:warning] = message
          redirect_to root_url
        end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
      #   ↑アクションを実行するとnewビュー表示される
    end
  end

  # deleteにDELETE送信するとログアウトする
  def destroy
    log_out if logged_in?   #logged_inがtrueの場合のみlog_outを実行する
    redirect_to root_url
  end

end
