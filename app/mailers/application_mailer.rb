class ApplicationMailer < ActionMailer::Base
  default from: ENV["DefaultFrom"] ? ENV["DefaultFrom"] : 'reporting@isatlbd.com'
 # layout 'mailer'
end
