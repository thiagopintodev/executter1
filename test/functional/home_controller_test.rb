require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get settings_profile" do
    get :settings_profile
    assert_response :success
  end

  test "should get settings_account" do
    get :settings_account
    assert_response :success
  end

  test "should get settings_password" do
    get :settings_password
    assert_response :success
  end

  test "should get settings_picture" do
    get :settings_picture
    assert_response :success
  end

  test "should get settings_design" do
    get :settings_design
    assert_response :success
  end

  test "should get settings_notice" do
    get :settings_notice
    assert_response :success
  end

end
