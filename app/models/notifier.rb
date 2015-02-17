class Notifier < ActionMailer::Base

  def register_form(user,organization,url)
    @user = user
    @organization = organization
    @url = url
    mail(
      subject: "Invitation Email",
      from: "no_reply@pindoit.com",
      to: user.email ,
      date: Time.now)
  end

end
