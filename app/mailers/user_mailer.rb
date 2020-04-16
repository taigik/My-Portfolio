class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "【重要】アカウントの有効化について"  # 件名
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "【重要】パスワードの再設定について"  # 件名
  end
end
