class PagesMailer < ActionMailer::Base
  default from: "contact_us@golaunchboard.com"
  default to: 'edwardforcpu@gmail.com'

  def email_us(name, email, message)
    @name = name
    @message = message
    @email = email
    mail(subject: "Email from #{@name}")
  end
end
