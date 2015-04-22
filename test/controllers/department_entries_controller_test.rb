require 'test_helper'

class DepartmentEntriesControllerTest < ActionController::TestCase
  setup do
    @department_entry = department_entries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:department_entries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create department_entry" do
    assert_difference('DepartmentEntry.count') do
      post :create, department_entry: { department_id: @department_entry.department_id, organization_id: @department_entry.organization_id }
    end

    assert_redirected_to department_entry_path(assigns(:department_entry))
  end

  test "should show department_entry" do
    get :show, id: @department_entry
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @department_entry
    assert_response :success
  end

  test "should update department_entry" do
    patch :update, id: @department_entry, department_entry: { department_id: @department_entry.department_id, organization_id: @department_entry.organization_id }
    assert_redirected_to department_entry_path(assigns(:department_entry))
  end

  test "should destroy department_entry" do
    assert_difference('DepartmentEntry.count', -1) do
      delete :destroy, id: @department_entry
    end

    assert_redirected_to department_entries_path
  end
end
