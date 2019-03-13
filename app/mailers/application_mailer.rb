class ApplicationMailer < ActionMailer::Base
  default from: ENV["DefaultForm"] ? ENV["DefaultForm"] : 'reporting@isatlbd.com'
 # layout 'mailer'
end
