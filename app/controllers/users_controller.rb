class UsersController < ApplicationController
  protect_from_forgery :except => [:destroy]
  before_action :logged_in_user, only: [:index, :edit, :update,
                                   :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  # ユーザー一覧
  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  # ユーザープロフィールページ + マイクロポスト
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to root_url and return unless @user.activated?
  end

  # ユーザー作成
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # 保存成功
      @user.send_activation_email
      flash[:info] = "メールアドレスに確認メールを送信しました。\n メールを確認してください。"
      redirect_to root_url
    else
      # 保存失敗
      render 'new'
    end
  end

  # ユーザー更新
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # 更新成功
      flash[:success] = "プロフィールを更新しました。"
      redirect_to @user
    else
      # 更新失敗
      render 'edit'
    end
  end

  # ユーザー削除
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーを削除しました。"
    redirect_to users_url
  end

  # フォローページ
  def following
    @title = "フォロー"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  # フォロワーページ
  def followers
    @title = "フォロワー"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  # Strong Parameters
  private

    # ユーザーに許可するパラメータ
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :picture)
    end

    # beforeアクション

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(user_url) unless current_user?(@user)
    end

    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
