class PagesMailer < ApplicationMailer
  default from: "contact_us@golaunchboard.com"
  default to: 'edwardforcpu@gmail.com'
  # default to: 'clinton@golaunchboard.com'

  def email_us(name, email, message)
    @name = name
    @message = message
    @email = email
    mail(subject: "Email from #{@name}")
  end
end
