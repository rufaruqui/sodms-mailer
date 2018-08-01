
class RetrieveClientContainerData
    def self.perform(options={})
        options = { :mailDeliverySettingsId=>1}
        access_token = 'Bearer ' + AuthService.authenticate;
        url = ENV["LOCAL_BACKEND_BASE"]+"/api/services/app/MailReport/RetrieveContainerClientReportForEmail";
        response = RestClient.post url, options.to_json, {:Authorization => access_token, content_type: :json, accept: :json}
        mailinfo = JSON.parse(response.body,symbolize_names: true )
        puts mailinfo[:result]

        puts "Stock Report"
        puts mailinfo[:result][:containerStockReport]
        if mailinfo[:success] == true
            return mailinfo[:result]
        else
            return nil
        end   
    end
end
