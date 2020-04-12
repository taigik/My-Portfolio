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
      # 保存成功
      log_in @user
      flash[:success] = "ようこそ！"
      redirect_to @user
    else
      # 保存失敗
      render 'new'
    end
  end

  # Strong Parameters
  private
    # ユーザーパラメータ
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
