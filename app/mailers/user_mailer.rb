class UserMailer < ApplicationMailer
  default from: "do-not-reply@golaunchboard.com"

  def sign_up_email(user)
    @user = user
    mail(subject: 'Welcome to Launchboard', to: @user.email)
  end

  def invite_email(organization, target_email)
    @organization = organization
    mail(subject: 'You have been invited to join Launchboard', to: target_email)
  end
end

