class AddApprovedToPostDepartmentEntries < ActiveRecord::Migration
  def change
    add_column :post_department_entries, :approved, :boolean, default: false
  end
end
