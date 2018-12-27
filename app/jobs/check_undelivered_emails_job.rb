class CheckUndeliveredEmailsJob < ApplicationJob
     extend Resque::Plugins::Retry
   
  queue_as :saplmailer
  def perform(options={}) 
    emails = Email.where.not(state: "sent").where('created_at >= ?', Time.now.to_datetime - 1.day)
     sent_emails emails
  end

   def sent_emails emails
    emails.each do  |email|
        options = Hash.new
        options[:recipents] = email.recipients
        options[:cc] = email.cc
        options[:filename]  = email.attachment
        options[:subject]   = email.subject
        options[:body]      = email.body
        options[:attachment_name] = email.attachment_name
        ReportMailer.daily_email_update(options).deliver!
        email.update(state: :sent)
    end
  end
end
