class DepartmentEntryMembership < ActiveRecord::Base
  belongs_to :department_entry
  belongs_to :user
end
