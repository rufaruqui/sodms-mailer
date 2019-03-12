 
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
        if !containerinfo.blank?
            if (recipents.blank? or recipents.nil?) and (cc.blank? or cc.nil?)
              Rails.logger.info '######## No Recipents  ##########' 
            else
              Rails.logger.info '########  Generate Excel Sheet                  ##########' 
              options[:mail_delivery_setting_id] = info[:id]
              options[:mail_type] = info[:mailReportType]
              options[:subject] = 'Import Container Movement & Stock Report -- ' + Time.now.to_date.to_s + ' for ' + info[:clientCode] + '  (' + info[:permittedDepotCode] + ')'
              options[:attachment_name]=[info[:permittedDepotCode], info[:clientCode], 'Import ContainerMovementReport', Time.now.to_date.to_s].join('_') + '.xlsx'
              options[:containerinfo] = containerinfo
              options[:recipents] = recipents
              options[:cc] = cc
              options[:body] = EmailService.import_container_report_email_body(info)
              options[:filename]  = ['./reports/',info[:permittedDepotCode], info[:clientCode], 'ImportContainerMovementReport', Time.now.to_date.to_s, info[:id],'.xlsx'].join('_')
              options[:clientid]  = info[:clientId]
              options[:permitteddepoid] = info[:permittedDepotId]
              options[:client_name] = info[:clientName]
              options[:client_code] = info[:clientCode]
              options[:permitted_depo_name] = info[:permittedDepotName]
              CreateImportContainerReportXls.perform(options)
            end  
        end
  end
end