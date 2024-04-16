# test/models/comment_test.rb
require "test_helper"

class CommentTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    user = User.create(email: 'test@example.com', password: 'password')
    post = user.posts.create(title: 'Test Post', body: 'Test Body')
    comment = post.comments.build(body: 'Nice post!', user: user)
    assert comment.valid?
  end

  test "should not be valid without a body" do
    comment = Comment.new(body: nil)
    assert_not comment.valid?
  end
end
