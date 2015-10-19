class Organizations < ApplicationMailer

  def notify_clinton(org)
    @user = org.managers.first
    mail(subject: "User #{@user.username} has signed up", to: 'clintonball@gmail.com')
  end

end
