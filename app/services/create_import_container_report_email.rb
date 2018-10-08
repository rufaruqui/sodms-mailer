 
class CreateImportContainerReportEmail

  def self.perform(info)  
      options={}
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
              options[:mail_delivery_setting_id] = info[:id]
              options[:mail_type] = info[:mailReportType]
              options[:subject] = 'Import Container Movement & Stock Report -- ' + Time.now.to_date.to_s + '--' + info[:clientName] + ' -- (' + info[:permittedDepotName] + ')'
              options[:attachment_name]=info[:clientName] + [info[:permittedDepotName], Time.now.to_date.to_s, info[:id], 'Import Container Movement & Stock Report','.xlsx'].join('_')
              options[:containerinfo] = containerinfo
              options[:recipents] = recipents
              options[:body] = EmailService.import_container_report_email_body(info)
              options[:filename]  = ['./reports/',info[:clientName],info[:permittedDepotName], 'import_container_report', Time.now.to_date.to_s, info[:id], '.xlsx'].join('_')
              options[:clientid]  = info[:clientId]
              options[:permitteddepoid] = info[:permittedDepotId]
              options[:client_name] = info[:clientName]
              options[:permitted_depo_name] = info[:permittedDepotName]
              CreateImportContainerReportXls.perform(options)
            end  
        end
  end
end