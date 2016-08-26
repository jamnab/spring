class UserInvite < ActiveRecord::Base
  belongs_to :department_entry
  belongs_to :organization
  belongs_to :user

  after_create :invite_email

  def invite_email
    url = Rails.env.production? ? request.host : request.host_with_port

    Notifier.user_invitation(email, organization, url, current_user).deliver_now
  end
end
