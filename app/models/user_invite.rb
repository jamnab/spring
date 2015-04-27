class UserInvite < ActiveRecord::Base
  belongs_to :department_entry
  has_one :organization, through: :department_entry
end
