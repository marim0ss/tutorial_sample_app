class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user   #ユーザー登録したらそのままログイン状態にさせる
      # 保存成功の時の処理
      flash[:success] = "Welcom to the Sample App!"
      redirect_to @user
      # ↑ redirect_to user_url(@userと一緒)
    else
      # 保存失敗の時
      render 'new'
    end
  end


# Rubyのprivateキーワードで、このメソッドを外部からは使えないようにできる
  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
