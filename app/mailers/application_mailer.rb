class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@golaunchboard.com'

  layout 'mailer'
end
