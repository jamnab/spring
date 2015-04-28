class CreateDepartmentEntryMemberships < ActiveRecord::Migration
  def change
    create_table :department_entry_memberships do |t|
      t.integer :user_id
      t.integer :department_entry_id
      t.boolean :admin, default: false

      t.timestamps
    end
  end
end
