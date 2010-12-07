require 'test_helper'

class HostnessesControllerTest < ActionController::TestCase
  setup do
    @hostness = hostnesses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:hostnesses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create hostness" do
    assert_difference('Hostness.count') do
      post :create, :hostness => @hostness.attributes
    end

    assert_redirected_to hostness_path(assigns(:hostness))
  end

  test "should show hostness" do
    get :show, :id => @hostness.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @hostness.to_param
    assert_response :success
  end

  test "should update hostness" do
    put :update, :id => @hostness.to_param, :hostness => @hostness.attributes
    assert_redirected_to hostness_path(assigns(:hostness))
  end

  test "should destroy hostness" do
    assert_difference('Hostness.count', -1) do
      delete :destroy, :id => @hostness.to_param
    end

    assert_redirected_to hostnesses_path
  end
end
