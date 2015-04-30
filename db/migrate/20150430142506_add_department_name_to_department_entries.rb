class AddDepartmentNameToDepartmentEntries < ActiveRecord::Migration
  def change
    add_column :department_entries, :department_name, :string
  end
end
