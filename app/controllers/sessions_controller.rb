class SessionsController < ApplicationController

# ログイン機能担当。

# ログインフォームをnewで処理
  def new
  end

  # createにPOST送信するとログインする
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    # authenticate... 認証に失敗した時にfalseを返すメソッド
    if user && user.authenticate(params[:session][:password])
      # log_in.....helper/sessions_helper.rbで定義したメソッド

      log_in user
      # if文と同等↓  @remember_meチェックボックス.checkされてたら記憶、外れてたら忘れる。remember userコードを書き換え
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)

      redirect_back_or user    #フレンドリーフォワーディングを備えたリダイレクト
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
