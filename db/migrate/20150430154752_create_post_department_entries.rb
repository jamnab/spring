class CreatePostDepartmentEntries < ActiveRecord::Migration
  def change
    create_table :post_department_entries do |t|
      t.string :department_entry_id
      t.integer :post_id

      t.timestamps
    end
  end
end
