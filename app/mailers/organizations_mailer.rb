class OrganizationsMailer < ApplicationMailer

  def notify_clinton(org)
    @user = org.managers.first
    mail(subject: "User #{@user.username} has signed up", to: 'clintonball@gmail.com')
  end

  def notify_user_wait_for_approval(org)
    @user = org.managers.first
    mail(subject: "Welcome to Launchboard, #{org.name}", to: @user.email)
  end

end
