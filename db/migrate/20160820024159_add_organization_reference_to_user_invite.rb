class AddOrganizationReferenceToUserInvite < ActiveRecord::Migration
  def change
    change_table :user_invites do |t|
      t.belongs_to :organization
    end
  end
end
