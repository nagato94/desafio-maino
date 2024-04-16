require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(email: 'test@example.com', password: 'password')
    @post = @user.posts.create(title: 'My first post', body: 'Hello, world!')
  end

  test "should get index" do
    get posts_url
    assert_response :success
  end

  test "should get show" do
    get post_url(@post)
    assert_response :success
  end
end
