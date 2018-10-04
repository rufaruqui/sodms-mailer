class ReportMailer < ApplicationMailer
  include Resque::Mailer 

   @queue='saplmailer'

  def  daily_email_update(options={}) 

    puts "Updating daily reports"
    puts options
   
    attachments[options[:attachment_name]] = File.read(options[:filename])
    mail(to: options[:recipents], subject: options[:subject], body: options[:body])

    # mail = Mail.new do 
    #   from     'sapl.mailer@gmail.com'
    #   to        options[:recipents]
    #   subject  'New Stock Report'
    #   body     'Sample body'
    #   add_file :filename => options[:filename], :content => File.read(options[:filename])
    # end
   
    #  return mail
  end
  

end