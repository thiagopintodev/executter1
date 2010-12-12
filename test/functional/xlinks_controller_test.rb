require 'test_helper'

class XlinksControllerTest < ActionController::TestCase
  setup do
    @xlink = xlinks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:xlinks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create xlink" do
    assert_difference('Xlink.count') do
      post :create, :xlink => @xlink.attributes
    end

    assert_redirected_to xlink_path(assigns(:xlink))
  end

  test "should show xlink" do
    get :show, :id => @xlink.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @xlink.to_param
    assert_response :success
  end

  test "should update xlink" do
    put :update, :id => @xlink.to_param, :xlink => @xlink.attributes
    assert_redirected_to xlink_path(assigns(:xlink))
  end

  test "should destroy xlink" do
    assert_difference('Xlink.count', -1) do
      delete :destroy, :id => @xlink.to_param
    end

    assert_redirected_to xlinks_path
  end
end
