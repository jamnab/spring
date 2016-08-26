class RenameUsersIdToUserId < ActiveRecord::Migration
  def change
    rename_column :user_invites, :users_id, :user_id
  end
end
