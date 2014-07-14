class CreateProjectMemberships < ActiveRecord::Migration
  def change
    create_table :project_memberships do |t|
      t.boolean :admin, default: false
      t.integer :project_id
      t.integer :user_id

      t.timestamps
    end
  end
end
