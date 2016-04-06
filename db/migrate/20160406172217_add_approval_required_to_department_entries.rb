class AddApprovalRequiredToDepartmentEntries < ActiveRecord::Migration
  def change
    add_column :department_entries, :approval_required, :boolean, default: false
  end
end
