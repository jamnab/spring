class DepartmentEntry < ActiveRecord::Base
  belongs_to :context, polymorphic: true
  belongs_to :department
end
