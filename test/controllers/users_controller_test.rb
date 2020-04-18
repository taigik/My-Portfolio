require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:example)
    @other_user = users(:example2)
    @non_activated_user = users(:non_activated)
  end

  # アカウント作成ページ
  test "should get new" do
    get signup_path
    assert_response :success
  end

  # ログインしていないユーザーをログインページへ
  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_redirected_to login_url
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  # 違うユーザーをマイプロフィールページへ
  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert_redirected_to user_url(@user)
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_redirected_to user_url(@user)
  end

  # admin属性の変更は禁止
  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: { user: { password:             @other_user.password,
                                                    password_confirmation: @other_user.password_confirmation,
                                                    admin: true } }
    assert_not @other_user.reload.admin?
  end

  # 管理者権限のテスト
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_path
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_path
  end

  # 有効化されていないユーザー
  test "should not allow the not activated attribute" do
    log_in_as(@non_activated_user)
    assert_not @non_activated_user.activated?
    get users_path
    assert_select "a[href=?]", user_path(@non_activated_user), count: 0
    get user_path(@non_activated_user)
    assert_redirected_to root_url
  end

  # フォローページの認可
  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  # フォロワーページの認可
  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end
end
