class UserInvite < ActiveRecord::Base
  belongs_to :department_entry
  belongs_to :organization
  belongs_to :user

  after_create :invite_email

  def invite_email
    Notifier.user_invitation(email, organization, user).deliver_now
  end
end
