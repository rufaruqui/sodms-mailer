require 'rest-client'

class RetrieveStockInfo
    def self.perform(options={})
        response = RestClient.post ENV["SODMS_BACKEND_BASE"]+"/api/services/app/ClientReport/RetrieveContainerStockReport", {'MailDeliverySettingId' => 3}.to_json, {content_type: :json, accept: :json}
        stockinfo = JSON.parse(response.body,symbolize_names: true )

        if stockinfo[:success] == true
            return stockinfo[:result][:items]
        else
            return nil
        end   
    end
end
