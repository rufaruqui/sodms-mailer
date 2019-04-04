class SendEmailReport
 def self.perform(options={})
    emails = Email.where('created_at >= ?', Time.now.to_datetime - 1.day)
    emails.each do  |email|
        options = Hash.new
        options[:recipents] = email.recipients
        options[:cc]        = email.cc
        options[:filename]  = email.attachment
        options[:subject]   = email.subject
        options[:body]      = email.body
        options[:attachment_name] = email.attachment_name
        ReportMailer.daily_email_update(options).deliver
   end
 end
end