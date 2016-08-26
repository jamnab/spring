class AddUserIdToUserInvite < ActiveRecord::Migration
  def change
    add_belongs_to(:user_invites, :users)
  end
end
