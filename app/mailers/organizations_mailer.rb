class OrganizationsMailer < ApplicationMailer

  def notify_clinton(org)
    @user = org.managers.first
    mail(subject: "A new organization #{org.name} has signed up", to: 'clintonball@gmail.com')
  end

  def notify_user_wait_for_approval(org)
    @user = org.managers.first
    mail(subject: "Welcome to Launchboard, #{org.name}", to: @user.email)
  end

  def notify_manager_of_approval(manager)
    org = manager.organization

    mail(subject: "Your organization #{org.name} has been approved.", to: manager.email)
  end

end
