 
class CreateImportContainerReportEmail

  def self.perform(info)  
      options={}
      ########### Extract Email Contacts from SODOMS MailDeliveryInfos ########
      recipents = info[:mailDeliveryContacts].pluck(:contactEmail).join(';')
      cc = ENV["ImportContainerCC"]

      Rails.logger.info '########  Retrive Stock Data from Sodms Backend ##########' 
      h = Hash.new 
      h = {:mailDeliverySettingsId=> info[:id]}   
      
      containerinfo = RetrieveImportContainerData.perform(h)
      puts containerinfo
      info[:summary] =  report_summary containerinfo unless containerinfo.blank?
     puts info[:summary]
        if !containerinfo.blank?
          Rails.logger.info '########  Generate Excel Sheet                  ##########' 
              options[:mail_delivery_setting_id] = info[:id]
              options[:mail_type] = info[:mailReportType]
              options[:subject] = 'Import Container Movement & Stock Report -- ' + Time.now.to_date.to_s + ' for ' + info[:clientCode] + '  (' + info[:permittedDepotCode] + ')'
              options[:recipents] = recipents
              options[:cc] = cc
              options[:clientid]  = info[:clientId]
              options[:permitteddepoid] = info[:permittedDepotId]
              options[:client_name] = info[:clientName]
              options[:client_code] = info[:clientCode]
              options[:permitted_depo_name] = info[:permittedDepotName]
            if info[:summary].values.sum  == 0
               options[:body] = EmailService.import_container_report_email_body(info)
               EmailService.create_email options
             else
              options[:attachment_name]=[info[:permittedDepotCode], info[:clientCode], 'Import ContainerMovementReport', Time.now.to_date.to_s].join('_') + '.xlsx'
              options[:containerinfo] = containerinfo
              options[:body] = EmailService.import_container_report_email_body(info)
              options[:filename]  = ['./reports/',info[:permittedDepotCode], info[:clientCode], 'ImportContainerMovementReport', Time.now.to_date.to_s, info[:id],'.xlsx'].join('_')
              CreateImportContainerReportXls.perform(options)
           end   
        end
  end

   def self.empty_report? response 
    response.each do |k, v|
         return !(v > 0)
    end
    return true
  end

  def self.report_summary container_data
      summary = Hash.new
      summary[:importInReport] =         container_data[:importInReport].blank? ? 0 : container_data[:importInReport].pluck(:containerNumber).uniq.count  
      summary[:importUnstuffingReport] = container_data[:importUnstuffingReport].blank? ? 0 : container_data[:importUnstuffingReport].pluck(:containerNumber).uniq.count  
      summary[:importFclOutReport] =     container_data[:importFclOutReport].blank? ? 0 : container_data[:importFclOutReport].pluck(:containerNumber).uniq.count  
      summary[:importLadenStockReport] = container_data[:importLadenStockReport].blank? ? 0 : container_data[:importLadenStockReport].pluck(:containerNumber).uniq.count  
      summary[:issueBalanceReport] =     container_data[:issueBalanceReport].blank? ? 0 : container_data[:issueBalanceReport].pluck(:containerNumber).uniq.count  

      return summary
  end
end