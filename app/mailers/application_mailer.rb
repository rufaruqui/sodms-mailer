class ApplicationMailer < ActionMailer::Base
  default from: ENV["DefaultFrom"] ? ENV["DefaultFrom"] : 'reporting@saplbd.com'
 # layout 'mailer'
end
