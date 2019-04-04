class ReportMailer < ApplicationMailer
  include Resque::Mailer 

   @queue='saplmailer'

  def  daily_email_update(options={}) 
    if options[:attachment_name].present?
     attachments[options[:attachment_name]] = File.read(options[:filename]) if  File.exist? (options[:filename])
    end
    mail(to: options[:recipents], 
         cc: options[:cc], 
         subject: options[:subject],
         body: options[:body]
         )
  end
  
  def self.perform(options={})
    daily_email_update(options).deliver
  end

end