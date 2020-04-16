class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "ようこそ！"
      redirect_to user
    else
      flash[:danger] = "リンクの有効期限が切れています。\n 再度アカウント作成を行ってください。"
      redirect_to root_url
    end
  end
end
