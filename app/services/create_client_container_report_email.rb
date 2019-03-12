 
class CreateClientContainerReportEmail
  def self.perform(info)  
       options = {} 
       recipents = info[:mailDeliveryContacts].pluck(:contactEmail).join(';')
       cc = ENV["EmptyContainerCC"]

       h = Hash.new 
       h = {:mailDeliverySettingsId=> info[:id]} 
       containerinfo = RetrieveClientContainerData.perform(h) 

       if !containerinfo.blank?
            if (recipents.blank? or recipents.nil?) and (cc.blank? or cc.nil?)
              Rails.logger.info '######## No Recipents  ##########' 
            elsif !empty_report? containerinfo
              Rails.logger.info '######## Nothing to send  ##########' 
            else
              Rails.logger.info '########  Generate Excel Sheet                  ##########' 
              options[:mail_delivery_setting_id] = info[:id]
              options[:mail_type] = info[:mailReportType]
              options[:subject] = 'Container Movement & Stock Report -- ' + Time.now.to_date.to_s + ' for ' + info[:clientCode] + '  (' + info[:permittedDepotCode] + ')'
              options[:attachment_name]=[info[:permittedDepotCode], info[:clientCode], 'ContainerMovementReport', Time.now.to_date.to_s,'.xlsx'].join('_')
              options[:containerinfo] = containerinfo
              options[:recipents] = recipents
              options[:cc] = cc
              options[:body] = EmailService.container_report_email_body(info)
              options[:filename]  = ['./reports/',info[:permittedDepotCode], info[:clientCode], 'ContainerMovementReport', Time.now.to_date.to_s, info[:id],'.xlsx'].join('_')
              options[:clientid]  = info[:clientId]
              options[:permitteddepoid] = info[:permittedDepotId]
              options[:client_name] = info[:clientName]
              options[:permitted_depo_name] = info[:permittedDepotName]
              CreateClientContainerReportXls.perform(options)
            end   
      end 
  end

  def self.empty_report? response
    response.each do |k, v|
         return v.length > 0
    end
    
    return false
  end
end