 
class CreateImportContainerReportEmail

  def self.perform(options={})  
    

    Rails.logger.info '########  Retrive Mail Delivery Settings ##########' 
    
    mailsdeliveryinfo = RetrieveMailDeliveryInfo.perform
     
    
   if !mailsdeliveryinfo.blank?
      mailsdeliveryinfo.each do |info| 
       
        
      if info[:mailReportType] == 1 
      #if info[:mailTypeId] == 2
      
        ########### Extract Email Contacts from SODOMS MailDeliveryInfos ########
        recipents = info[:mailDeliveryContacts].pluck(:contactEmail).join(';')
      

        Rails.logger.info '########  Retrive Stock Data from Sodms Backend ##########' 
      
        h = Hash.new 
        h = {:mailDeliverySettingsId=> info[:id]} 
        
        containerinfo = RetrieveImportContainerData.perform(h)
        if !containerinfo.blank?
            if recipents.blank? or recipents.nil?
              Rails.logger.info '######## No Recipents  ##########' 
            else

              Rails.logger.info '########  Generate Excel Sheet                  ##########' 
              options[:mail_type] = info[:mailReportType]
              options[:subject] = 'Import Container Movement & Stock Report -- ' + Time.now.to_date.to_s + '--' + info[:clientName] + ' -- (' + info[:permittedDepotName] + ')'
              options[:attachment_name]=[info[:clientName],info[:permittedDepotName], Time.now.to_date.to_s, info[:id], 'Import Container Movement & Stock Report','.xlsx'].join('_')
              options[:containerinfo] = containerinfo
              options[:recipents] = recipents
              options[:body] = report_email_body(info)
              options[:filename]  = ['./reports/',info[:clientName],info[:permittedDepotName], 'import_container_report', Time.now.to_date.to_s, info[:id], '.xlsx'].join('_')
              options[:clientid]  = info[:clientId]
              options[:permitteddepoid] = info[:permittedDepotId]
              #puts containerinfo[:importLadenStockReport][0] unless containerinfo[:importLadenStockReport].blank?
              CreateImportContainerReportXls.perform(options)
            end  
          end    
      end 
    end
    #  emails = Email.where('created_at >= ?', Time.now.to_datetime - 1.day)
    #  emails.each do  |email|
    #     options = Hash.new
    #     options[:recipents] = email.recipients
    #     options[:filename]  = email.attachment
    #     options[:subject]   = email.subject
    #     options[:body]      = email.body
    #     ReportMailer.daily_email_update(options).deliver_at(Time.now)
    #   end
    end   
  end

  def self.report_email_body (info)
          <<-EOF 
             Dear #{info[:clientName]},
                
                Kindly see the attached Import Container Combining Report for the Date 01/10/2018.
                
                Client Name: #{info[:clientName]}  Client Code: #{info[:clientName]}
                Depot      :  #{info[:permittedDepotName]}
                
                Container Combining Report Includes:
                  1. In Report
                  2. In Summary
                  3. Unstuffing Report
                  4. Unstuffing Summary
                  5. FCL Out Report
                  6. FCL Out Summary
                  7. Laden Stock Report
                  8. Laden Stock Summary
              
                NB: This is a system generated mail sent automatically. So if you found any problem in the report, please contact with our respective person.

              Best Regards
              Customer Service Department
              #{info[:permittedDepotName]}
         EOF

        end

end