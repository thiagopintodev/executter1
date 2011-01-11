require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get emails" do
    get :emails
    assert_response :success
  end

  test "should get numbers" do
    get :numbers
    assert_response :success
  end

end
