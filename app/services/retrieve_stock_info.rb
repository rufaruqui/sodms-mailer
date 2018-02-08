require 'rest-client'

class RetrieveStockInfo
    def self.perform(options={})
        puts "Calling RetrieveStockInfo "
        # puts options
        # response = RestClient.post ENV["SODMS_BACKEND_BASE"]+"/api/services/app/ClientReport/RetrieveContainerStockReport", options.to_json, {content_type: :json, accept: :json}
        # if response.code == 200
        #      stockinfo = JSON.parse(response.body,symbolize_names: true )  

        #      if stockinfo[:success] == true
        #          return stockinfo[:result][:items]
        #      else
        #          return nil
        #      end   
        #  else
        #     return nil
        # end        
    end
end
