class AddSocialFeedsToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :twitter_handle, :string
    add_column :organizations, :twitter_widget_id, :string
    add_column :organizations, :facebook_page_handle, :string
  end
end
