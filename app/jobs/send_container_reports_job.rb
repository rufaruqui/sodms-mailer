class SendContainerReportsJob < ApplicationJob
   extend Resque::Plugins::Retry
   
  queue_as :saplmailer
  def perform(options={}) 
   if options.key? :id
      sent_emails [Email.find(options[:id])]
   elsif options.key? :state
      sent_emails Email.where(state: options[:state].downcase.to_sym) 
   else   
     sent_emails Email.where('created_at >= ?', Time.now.to_datetime - 1.day)
   end
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
 