require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                    password: "foobar", password_confirmation: "foobar")
  end

  # Userの有効性
  test "should be valid" do
    assert @user.valid?
  end

  # nameの存在性
  test "name should be present" do
    @user.name = "    "
    assert_not @user.valid?
  end

  # emailの存在性
  test "email should be present" do
    @user.email = "    "
    assert_not @user.valid?
  end

  # nameの長さ
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  # emailの長さ
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  # emailの有効性
  test "email validation should accept valid address" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                        first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
    @user.email = valid_address
    assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  # emailの無効性
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
    @user.email = invalid_address
    assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  # emailの一意性
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  # emailの小文字化
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  # passwordは空でない
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  # passwordの長さ
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  # ダイジェストが存在しない場合のauthenticated?のテスト
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  # dependent: :destroyのテスト
  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "content")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  # follow and unfollow メソッド
  test "should follow and unfollow a user" do
    example = users(:example)
    example2 = users(:example2)
    assert_not example.following?(example2)
    # フォロー
    example.follow(example2)
    assert example.following?(example2)
    assert example2.followers.include?(example)
    # フォロー解除
    example.unfollow(example2)
    assert_not example.following?(example2)
  end

  # フィード
  test "feed should have the right posts" do
    example = users(:example)
    example2 = users(:example2)
    example3 = users(:example3)
    # フォローしているユーザーの投稿がある
    example3.microposts.each do |post_following|
      assert example.feed.include?(post_following)
    end
    # 自分の投稿がある
    example.microposts.each do |post_self|
      assert example.feed.include?(post_self)
    end
    # フォローしていないユーザーの投稿がない
    example2.microposts.each do |post_unfollow|
      assert_not example.feed.include?(post_unfollow)
    end


    assert_not example.following?(example2)
    # フォロー
    example.follow(example2)
    assert example.following?(example2)
    assert example2.followers.include?(example)
    # フォロー解除
    example.unfollow(example2)
    assert_not example.following?(example2)
  end

end
