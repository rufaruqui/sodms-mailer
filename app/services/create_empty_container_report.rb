class CreateEmptyContainerReport
    def self.perform(options={})  
    

        Rails.logger.info '########  Retrive Mail Delivery Settings ##########'     

        empty_mailsdeliveryinfo = RetrieveMailDeliveryInfo.perform({:mailReportType=>0})        
        
        if !empty_mailsdeliveryinfo.blank?
            empty_mailsdeliveryinfo.each do |info|     
                if info[:mailReportType] == 0  #Empty Container Report
                   CreateClientContainerReportEmail.perform(info)
                end
            end
        end
        true
    end
end