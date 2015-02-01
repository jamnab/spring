class PagesMailer < ActionMailer::Base
  default from: "infosyncidlabs@gmail.com"
  default to: 'clinton@versesoftwarelab.com'

  def email_us(name, email, message)
    @name = name
    @message = message
    @email = email
    mail(subject: "Email from #{@name}")
  end
end
