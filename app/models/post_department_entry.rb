class PostDepartmentEntry < ActiveRecord::Base
  belongs_to :post
  belongs_to :department_entry
end
