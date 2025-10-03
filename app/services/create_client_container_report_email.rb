class CreateClientContainerReportEmail
  def self.perform(info)  
       options = {} 
       recipents = info[:mailDeliveryContacts].pluck(:contactEmail).join(';')
       cc = ENV["EmptyContainerCC"]

       h = Hash.new 
       h = {:mailDeliverySettingsId=> info[:id]} 
       containerinfo = RetrieveClientContainerData.perform(h) 
       info[:summary] =  report_summary containerinfo
   
       if !containerinfo.blank?
              options[:mail_delivery_setting_id] = info[:id]
              options[:mail_type] = info[:mailReportType]
              options[:subject] = 'Container Movement & Stock Report -- ' + Time.now.to_date.to_s + ' for ' + info[:clientCode] + '  (' + info[:permittedDepotCode] + ')'
              options[:recipents] = recipents
              options[:cc] = cc
              options[:clientid]  = info[:clientId] 
              options[:permitteddepoid] = info[:permittedDepotId]
              options[:client_name] = info[:clientName]
              options[:client_code] = info[:clientCode]
              options[:permitted_depo_name] = info[:permittedDepotName]  
            if info[:summary].values.sum  == 0
              Rails.logger.info '######## Nothing to send  ##########' 
              options[:body] = EmailService.container_report_email_body(info)
              EmailService.create_email options
            else
              Rails.logger.info '########  Generate Excel Sheet                  ##########' 
              options[:containerinfo] = containerinfo
              options[:body] = EmailService.container_report_email_body(info)
              options[:attachment_name]=[info[:permittedDepotCode], info[:clientCode], 'ContainerMovementReport', Time.now.to_date.to_s].join('_')+'.xlsx'
              options[:filename]  = ['./reports/',info[:permittedDepotCode], info[:clientCode], 'ContainerMovementReport', Time.now.to_date.to_s, info[:id],'.xlsx'].join('_')
              CreateClientContainerReportXls.perform(options)
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
      summary[:inReport]         = container_data[:containerInReport].blank? ? 0 : container_data[:containerInReport].pluck(:containerNumber).uniq.count
      summary[:outEmptyReport]   = container_data[:containerEmptyOutReport].blank? ? 0 : container_data[:containerEmptyOutReport].pluck(:containerNumber).uniq.count
      summary[:outLadenReport]   = container_data[:containerLadenOutReport].blank? ? 0 : container_data[:containerLadenOutReport].pluck(:containerNumber).uniq.count
      summary[:stockReport]      = container_data[:containerStockReport].blank? ? 0 : container_data[:containerStockReport].pluck(:containerNumber).uniq.count
      summary[:ladenStockReport] = container_data[:containerLadenStockCombiningReport].blank? ? 0 : container_data[:containerLadenStockCombiningReport].pluck(:containerNumber).uniq.count
      return summary
  end
end
 