class SendEmailReportsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
     emails = Email.where('created_at >= ?', Time.now.to_datetime - 1.day)
     emails.each do  |email|
        options = Hash.new
        options[:recipents] = email.recipients
        options[:filename]  = email.attachment
        options[:subject]   = email.subject
        options[:body]      = email.body
        options[:attachment_name] = email.attachment_name
        ReportMailer.daily_email_update(options).deliver_at(Time.now)
      end
  end
end
