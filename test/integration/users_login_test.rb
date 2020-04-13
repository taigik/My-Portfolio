require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:example)
  end

  # 無効なログイン
  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  # 有効なログイン・ログアウト
  test "login with valid information followed by logout" do
    # ログイン
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    # ログアウト
    get logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # 2番目のウィンドウでログアウトをクリックしたとき
    get logout_path
    follow_redirect!
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  # remember_me チェックボックスがオン
  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end

  # remember_me チェックボックスがオフ
  test "login without remembering" do
    # クッキーを保存してログイン・ログアウト
    log_in_as(@user, remember_me: '1')
    get logout_path
    # クッキーを削除してログイン
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end
end
