class BetaSignUpMailer < ApplicationMailer
  default from: 'beta@golaunchboard.com'

  def beta_mailing_list_to_clint(bsu)
    @email = bsu.email
    @name = "#{bsu.first_name} #{bsu.last_name}"
    mail(subject: "#{@name} wish to be added to beta mailing list", to: "accounts@portfolio10.com")
  end

  def approved(bsu)
    @bsu = bsu
    mail(subject: "You have been approved to sign up", to: @bsu.email)
  end

  def denied(bsu)
    @bsu = bsu
    mail(subject: "Your beta application was not approved", to: @bsu.email)
  end
end
