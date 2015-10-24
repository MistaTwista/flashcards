class ApplicationMailer < ActionMailer::Base
  default from: ENV["SENDMAIL_FROM"]
  layout "mailer"
end
