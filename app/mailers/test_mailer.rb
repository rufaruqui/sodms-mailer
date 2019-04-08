class TestMailer < ApplicationMailer
    include Resque::Mailer 

   @queue='saplmailer'

  def  daily_email_update(options={}) 
  # options[:attachment_name] = "sample.xlsx"
  # options[:filename]="./reports/sample.xlsx"

    puts "Sending test mail"  
     @mail = mail(to: 'rufaruqui@gmail.com', 
         cc: 'rokan@cu.ac.bd', 
         subject: 'Testing action mailer from SAPL Server',
         body: '<h1> Welcome to Ruby Mailer</h2>' 
         )
    @mail.html_part do
            content_type 'text/html; charset=UTF-8'
             body '<h1>This is HTML</h1>'
    end
    #@mail.attachments[options[:attachment_name]] = { mime_type:'multipart/mixed', content_type:'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', content: File.read(options[:filename]) } if File.exist?  (options[:filename])
  
  end

  def self.perform(options={})
    daily_email_update(options).deliver!
  end


end
