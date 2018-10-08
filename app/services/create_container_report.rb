class CreateContainerReport
    def self.perform(options={})  
    

        Rails.logger.info '########  Retrive Mail Delivery Settings ##########'     
        mailsdeliveryinfo = RetrieveMailDeliveryInfo.perform
            
        if !mailsdeliveryinfo.blank?
            mailsdeliveryinfo.each do |info|     
                if info[:mailReportType] == 0  #Empty Container Report
                    CreateClientContainerReportEmail.perform(info)
                elsif info[:mailReportType] == 1 #Import Container Report
                    CreateImportContainerReportEmail.perform(info)
                end
            end
        end
    end
end