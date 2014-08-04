require 'test_helper'

class TagEntriesControllerTest < ActionController::TestCase
  setup do
    @tag_entry = tag_entries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tag_entries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tag_entry" do
    assert_difference('TagEntry.count') do
      post :create, tag_entry: { tag_id: @tag_entry.tag_id, taggable_id: @tag_entry.taggable_id, taggable_type: @tag_entry.taggable_type }
    end

    assert_redirected_to tag_entry_path(assigns(:tag_entry))
  end

  test "should show tag_entry" do
    get :show, id: @tag_entry
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tag_entry
    assert_response :success
  end

  test "should update tag_entry" do
    patch :update, id: @tag_entry, tag_entry: { tag_id: @tag_entry.tag_id, taggable_id: @tag_entry.taggable_id, taggable_type: @tag_entry.taggable_type }
    assert_redirected_to tag_entry_path(assigns(:tag_entry))
  end

  test "should destroy tag_entry" do
    assert_difference('TagEntry.count', -1) do
      delete :destroy, id: @tag_entry
    end

    assert_redirected_to tag_entries_path
  end
end
