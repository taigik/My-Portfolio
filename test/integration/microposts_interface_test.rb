require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:example)
    @other_user = users(:example2)
  end

  # マイクロポストのUIに対する統合テスト:admin
  test "admin_user micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'h1', @user.name
    assert_select 'span', /#{@user.microposts.count}/
    assert_select 'form[action="/microposts"]'
    assert_select 'textarea'
    assert_select 'input[type="file"]'
    # 無効な送信
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_select 'div#error_explanation'
    # 有効な送信
    content = "This micropost really ties the room together"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content, picture: picture } }
    end
    assert assigns(:micropost).picture?
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # 投稿を削除する
    assert_select 'a', button: '削除'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # 違うユーザーのプロフィールにアクセス (削除リンクがないことを確認)
    get user_path(users(:example2))
    assert_select 'a', button: '削除'
  end

  # マイクロポストのUIに対する統合テスト:non_admin
  test "non_admin_user micropost interface" do
    log_in_as(@other_user)
    get root_path
    assert_select 'h1', @other_user.name
    assert_select 'span', /#{@other_user.microposts.count}/
    assert_select 'form[action="/microposts"]'
    assert_select 'textarea'
    assert_select 'input[type="file"]'
    # 無効な送信
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_select 'div#error_explanation'
    # 有効な送信
    content = "This micropost really ties the room together"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content, picture: picture } }
    end
    assert assigns(:micropost).picture?
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # 投稿を削除する
    assert_select 'a', button: '削除'
    first_micropost = @other_user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # 違うユーザーのプロフィールにアクセス (削除リンクがないことを確認)
    get user_path(users(:example3))
    assert_no_difference 'Micropost.count' do
      delete micropost_path(first_micropost)
    end
  end

  # サイドバーにあるマイクロポストの合計投稿数
  test "micropost sidebar count" do
    log_in_as(@user)
    get root_path
    # まだマイクロポストを投稿していないユーザー
    other_user = users(:example4)
    log_in_as(other_user)
    get root_path
    assert_match "0", response.body
    other_user.microposts.create!(content: "A micropost")
    get root_path
    assert_match "1", response.body
  end
end
