ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings =
{
  :address => "mail.syncidlabs.com",
  :port => 26, :domain => "syncidlabs.com",
  :user_name => "test@syncidlabs.com",
  :password => "[testaccount]",
  :enable_starttls_auto => true, :openssl_verify_mode => 'none'
}
