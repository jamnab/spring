class UserInvite < ActiveRecord::Base
  belongs_to :department_entry
  has_one :organization, through: :department_entry

  after_create :invite_email

  def invite_email
    UserMailer.invite_email(self.organization, self.email).deliver_now
  end
end
