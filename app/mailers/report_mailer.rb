class ReportMailer < ApplicationMailer
  include Resque::Mailer 

   @queue='sapl'

  def  daily_email_update(options={}) 

    puts "Updating daily reports"
   
    attachments[options[:filename]] = File.read(options[:filename])
    mail(to: options[:recipents], subject: 'New SAPL Report with attacment')

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