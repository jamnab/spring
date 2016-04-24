require 'test_helper'

class DepartmentEntryMembershipsControllerTest < ActionController::TestCase
  setup do
    @department_entry_membership = department_entry_memberships(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:department_entry_memberships)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create department_entry_membership" do
    assert_difference('DepartmentEntryMembership.count') do
      post :create, department_entry_membership: { admin: @department_entry_membership.admin, department_entry_id: @department_entry_membership.department_entry_id, user_id: @department_entry_membership.user_id }
    end

    assert_redirected_to department_entry_membership_path(assigns(:department_entry_membership))
  end

  test "should show department_entry_membership" do
    get :show, id: @department_entry_membership
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @department_entry_membership
    assert_response :success
  end

  test "should update department_entry_membership" do
    patch :update, id: @department_entry_membership, department_entry_membership: { admin: @department_entry_membership.admin, department_entry_id: @department_entry_membership.department_entry_id, user_id: @department_entry_membership.user_id }
    assert_redirected_to department_entry_membership_path(assigns(:department_entry_membership))
  end

  test "should destroy department_entry_membership" do
    assert_difference('DepartmentEntryMembership.count', -1) do
      delete :destroy, id: @department_entry_membership
    end

    assert_redirected_to department_entry_memberships_path
  end
end
