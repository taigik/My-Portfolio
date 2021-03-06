class SessionsController < ApplicationController

  def new
  end

  # ログイン
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      # ログイン成功:ユーザーログイン後にユーザー情報のページにリダイレクトする
      if @user.activated?
        log_in @user
        # remember_meがオンのとき'1'、オフのとき'0'
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        # 記憶したURL (もしくはデフォルト値) にログイン後にリダイレクト
        redirect_back_or @user
      else
        message = "アカウントが有効化されていません。\n"
        message += "メールを確認してアカウントを有効化してください。"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      # ログイン失敗:エラーメッセージを作成する
      flash.now[:danger] = 'メールかパスワードが正しくありません'
      render 'new'
    end
  end

  # ログアウト
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
