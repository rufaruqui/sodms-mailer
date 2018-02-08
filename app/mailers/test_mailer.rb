class TestMailer < ApplicationMailer
    include Resque::Mailer 

   @queue='saplmailer'

  def  daily_email_update(options={}) 

    puts "Sending test mail"
    #options[:to]="rufaruqui@gmail.com"
    #attachments[options[:filename]] = File.read(options[:filename])
    mail(to: 'rufaruqui@gmail.com', subject: 'Testing action mailer using Time.now')

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
