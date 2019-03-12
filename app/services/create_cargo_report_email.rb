 
class CreateCargoReportEmail
  def self.perform(info)  
       options = {} 
       recipents = info[:mailDeliveryContacts].pluck(:contactEmail).join(';')
       cc = ENV["CargoStatusCC"]

       h = Hash.new 
       h = {:mailDeliverySettingsId=> info[:id]} 
      cargoinfo = RetrieveCargoData.perform(h) 

       if !cargoinfo.blank?
            if (recipents.blank? or recipents.nil?) and (cc.blank? or cc.nil?)
              Rails.logger.info '######## No Recipents  ##########' 
            elsif !empty_report? cargoinfo
              Rails.logger.info '######## Nothing to send  ##########' 
            else
              Rails.logger.info '########  Generate Excel Sheet                  ##########' 
              options[:mail_delivery_setting_id] = info[:id]
              options[:mail_type] = info[:mailReportType]
              options[:subject] = 'Cargo Report -- ' + Time.now.to_date.to_s + '--' + info[:clientName] + ' -- (' + info[:permittedDepotName] + ')'
              options[:attachment_name]=info[:clientName] + [info[:permittedDepotName], Time.now.to_date.to_s, info[:id], 'Container Movement & Stock Report','.xlsx'].join('_')
              options[:cargoinfo] = cargoinfo
              options[:recipents] = recipents
              options[:cc] = cc
              options[:body] = EmailService.cargo_report_email_body(info)
              options[:filename]  = ['./reports/',info[:clientName],info[:permittedDepotName], 'cargo_report', Time.now.to_date.to_s, info[:id], '.xlsx'].join('_')
              options[:clientid]  = info[:clientId]
              options[:permitteddepoid] = info[:permittedDepotId]
              options[:client_name] = info[:clientName]
              options[:permitted_depo_name] = info[:permittedDepotName]
              CreateCargoReportXls.perform(options)
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