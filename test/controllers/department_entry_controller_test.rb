require 'test_helper'

class DepartmentEntryControllerTest < ActionController::TestCase
  test "should get department_name:string" do
    get :department_name:string
    assert_response :success
  end

  test "should get context_id:integer" do
    get :context_id:integer
    assert_response :success
  end

  test "should get context_type:string" do
    get :context_type:string
    assert_response :success
  end

end
