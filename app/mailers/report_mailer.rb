class ReportMailer < ApplicationMailer
  include Resque::Mailer

  def daily_email_update(options) 
    puts "Sending daily reports"
    # mail(to: 'rufaruqui@gmail.com', subject: 'SAPL Report')
  end

end