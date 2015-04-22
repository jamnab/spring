class CreateDepartmentEntries < ActiveRecord::Migration
  def change
    create_table :department_entries do |t|
      t.integer :context_id
      t.string :context_type
      t.integer :department_id

      t.timestamps
    end
  end
end
