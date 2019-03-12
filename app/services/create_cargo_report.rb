class CreateCargoReport
    def self.perform(options={})  
    

        Rails.logger.info '########  Retrive Mail Delivery Settings ##########'     
        mailsdeliveryinfo = RetrieveMailDeliveryInfo.perform({:mailReportType=>2})
            
        if !mailsdeliveryinfo.blank?
            mailsdeliveryinfo.each do |info|   
                 if info[:mailReportType] == 2  #CargoReport7Sheets
                    CreateCargoReportEmail.perform(info) 
                 end
            end
        end
    end
end