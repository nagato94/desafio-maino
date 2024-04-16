# test/models/post_test.rb
require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    user = User.create(email: 'test@example.com', password: 'password')
    post = user.posts.build(title: 'My first post', body: 'Hello, world!')
    assert post.valid?
  end

  test "should not be valid without a title" do
    post = Post.new(title: nil)
    assert_not post.valid?
  end

  test "should not be valid without a body" do
    post = Post.new(body: nil)
    assert_not post.valid?
  end
end
