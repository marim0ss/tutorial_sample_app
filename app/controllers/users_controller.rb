class UsersController < ApplicationController

  # ログインしているユーザーかどうか確認してから操作させている
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]

  before_action :correct_user, only: [:edit, :update]

  # destroyを管理者だけが行えるように指定
  before_action :admin_user,  only: :destroy


  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
=begin
      log_in @user   #ユーザー登録したらそのままログイン状態にさせる
      # 保存成功の時の処理
      flash[:success] = "Welcom to the Sample App!"
      redirect_to @user
      # ↑ redirect_to user_url(@userと一緒)
=end

      # 11.23 アカウント有効化を追加 11.36モデルからメールを送信する
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      # 保存失敗の時
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Profile deleted"
    redirect_to users_url     #indexへリダイレクト
  end

  # Rubyのprivateキーワードで、このメソッドを外部からは使えないようにできる=================
  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # before_action
    # ログイン済みのユーザーかどうか確認する
    def logged_in_user
      unless logged_in?
        store_location   # リクエストしたページを保存  app/helpers/sessions_helper.rbで定義したメソッド
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # 正しいユーザーかどうか確認、別のユーザーがedit,updateできないようにする
        # edit,updateの@user = User(params[:id])の代わりにこれを使用
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)     #current_user?メソッド：app/helpers/sessions_helper.rb
    end

    # 管理者かどうか確認   現在のユーザーがadmin=trueにならない時はリダイレクト
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
