require 'rest-client'

class RetrieveMailDeliveryInfo
    def self.perform(options={})
        access_token = 'Bearer ' + AuthService.authenticate;
        response = RestClient.post ENV["SODMS_BACKEND_BASE"]+"/api/services/app/MailDeliverySetting/RetrieveMailDeliveryInfos", { }.to_json, {:Authorization => access_token, content_type: :json, accept: :json}
        mailinfo = JSON.parse(response.body,symbolize_names: true )

        if mailinfo[:success] == true
            return mailinfo[:result][:items]
        else
            return nil
        end   
    end
end
