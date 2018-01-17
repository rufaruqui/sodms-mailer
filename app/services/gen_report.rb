 
class GenReport

  def self.perform(options={})  
    

    Rails.logger.info '########  Retrive Mail Delivery Settings ##########'
    puts '########  Retrive Mail Delivery Settings ##########'
    
    mailsdeliveryinfo = RetrieveMailDeliveryInfo.perform

    mailsdeliveryinfo.each do |info|

      ########### Extract Email Contacts from SODOMS MailDeliveryInfos ########
       recipents = info[:mailDeliveryContacts].pluck(:contactEmail).join(';')
    

      Rails.logger.info '########  Retrive Stock Data from Sodms Backend ##########'
      puts '########  Retrive Stock Data from Sodms Backend ##########'
       
       

      h = Hash.new
      h[:mailDeliverySettingId]=info[:id]
      stockinfo = RetrieveStockInfo.perform(h)
        
      if !stockinfo.blank?
          if recipents.blank? or recipents.nil?
            Rails.logger.info '######## No Recipents  ##########'
            puts '########## No Recipents ##########'
          else

            Rails.logger.info '########  Generate Excel Sheet                  ##########'
            puts '########  Generate Excel Sheet                  ##########'
            
            options[:stockinfo] = stockinfo
            options[:recipents] = recipents
            options[:filename]  = './reports/'+'stockreport'+Time.now.to_s+'.xlsx'
            GenStockReportXls.perform(options)
            
            Rails.logger.info '########  Send mail with excel reports as attacment######'
            puts '########  Send mail with excel reports as attacment######'

            Rails.logger.info Time.now
            
          #  options = Hash.new
          #  options[:recipents]="rufaruqui@gmail.com;"
          #  options[:filename]="simple.xlsx"

           ReportMailer.daily_email_update(options).deliver_at(Time.now)
          end  
        end    
     end 
  end

end