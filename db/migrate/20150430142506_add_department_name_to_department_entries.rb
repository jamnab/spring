class AddDepartmentNameToDepartmentEntries < ActiveRecord::Migration
  def change
    add_column :department_entries, :department_name, :string
    add_column :department_entries, :abbrev_name, :string
  end
end
