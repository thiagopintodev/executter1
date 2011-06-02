require 'test_helper'

class PureControllerTest < ActionController::TestCase
  test "should get users" do
    get :users
    assert_response :success
  end

  test "should get user_photos" do
    get :user_photos
    assert_response :success
  end

  test "should get posts" do
    get :posts
    assert_response :success
  end

end
