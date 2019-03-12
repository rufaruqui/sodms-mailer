class CreateImportContainerReport
    def self.perform(options={})  
    

        Rails.logger.info '########  Retrive Mail Delivery Settings ##########'     
   
        import_mailsdeliveryinfo = RetrieveMailDeliveryInfo.perform({:mailReportType=>1})    
        
        if !import_mailsdeliveryinfo.blank?
            import_mailsdeliveryinfo.each do |info|     
                if info[:mailReportType] == 1 #Import Container Report
                    CreateImportContainerReportEmail.perform(info)
                end
            end
        end
    end
end