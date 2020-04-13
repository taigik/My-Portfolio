require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
    @user = users(:example)
  end

  # rootのテスト
  test "should get root" do
    get root_url
    assert_response :success
  end

  # Homeページのテスト
  test "should get home" do
    get root_path
    assert_response :success
    assert_select "title", "#{@base_title}"
  end

  # Helpページのテスト
  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", "Help | #{@base_title}"
  end

  # Aboutページのテスト
  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "About | #{@base_title}"
  end

  # Contactページのテスト
  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "Contact | #{@base_title}"
  end

  # ログインしているユーザーをマイプロフィールページへ
  test "should redirect root when logged in" do
    log_in_as(@user)
    get root_path
    assert_redirected_to user_url(@user)
  end

end
