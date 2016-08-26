class DepartmentEntryMembership < ActiveRecord::Base
  belongs_to :department_entry
  belongs_to :user

  after_create :invite_email

  def invite_email
    url = Rails.env.production? ? request.host : request.host_with_port

    if self.department_entry.context.is_a? Organization
      Notifier.new_department_assignment(user, department_entry.context, url, department_entry.department_name).deliver_now
    end
  end
end
