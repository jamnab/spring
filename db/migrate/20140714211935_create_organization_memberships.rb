class CreateOrganizationMemberships < ActiveRecord::Migration
  def change
    create_table :organization_memberships do |t|
      t.boolean :admin, default: false
      t.integer :organization_id
      t.integer :user_id

      t.timestamps
    end
  end
end
