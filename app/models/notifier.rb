class Notifier < ActionMailer::Base

  def register_form(user,organization,url)
    @user = user
    @organization = organization
    @url = url
    mail(
      subject: "Message",
      from: "infosyncidlabs@gmail.com",
      to: user.email ,
      date: Time.now)
  end
  
end