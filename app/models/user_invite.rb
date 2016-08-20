class UserInvite < ActiveRecord::Base
  belongs_to :department_entry
  belongs_to :organization

  after_create :invite_email

  def invite_email
    UserMailer.invite_email(self.organization, self.email).deliver_now
  end
end
