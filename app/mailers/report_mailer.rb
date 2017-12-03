class ReportMailer < ApplicationMailer
  include Resque::Mailer

  def daily_email_update(options)
    p "Sending daily reports"
     mail(to: 'rufaruqui@gmail.com', subject: 'Welcome to My Awesome Site')
  end

end