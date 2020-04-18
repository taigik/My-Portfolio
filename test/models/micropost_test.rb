require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:example)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  # micropostの有効性
  test "should be valid" do
    assert @micropost.valid?
  end

  # user_idの存在性
  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

    # contentの存在性
  test "content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  # contentの長さ
  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  # 新しいものから順に表示
  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
