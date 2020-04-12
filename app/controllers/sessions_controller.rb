class SessionsController < ApplicationController

  def new
  end

  # ログイン
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # ログイン成功:ユーザーログイン後にユーザー情報のページにリダイレクトする
      log_in user
      redirect_to user
    else
      # ログイン失敗:エラーメッセージを作成する
      flash.now[:danger] = 'メールかパスワードが正しくありません'
      render 'new'
    end
  end

  # ログアウト
  def destroy
    log_out
    redirect_to root_url
  end
end
