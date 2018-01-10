class ReportMailer < ApplicationMailer
  include Resque::Mailer 

   @queue='sapl'

  def  daily_email_update(options={}) 

    puts "Updating daily reports"
   
    attachments['simple.xlsx'] = File.read('simple.xlsx')
    mail(to: 'rufaruqui@gmail.com', subject: 'New SAPL Report with attacment')

    # mail = Mail.new do 
    #   from     'sapl.mailer@gmail.com'
    #   to       'rufaruqui@gmail.com'
    #   subject  'New Stock Report'
    #   body     'Sample body'
    #   add_file :filename => options[:filename], :content => File.read(options[:filename])
    # end
   
    # return mail
  end

end