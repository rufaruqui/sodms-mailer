require 'rest-client'

class RetrieveStockInfo
    def self.perform(options={})
        puts "Calling RetrieveStockInfo "
        #puts options
        access_token = 'Bearer ' + AuthService.authenticate;
        url = ENV["LOCAL_BACKEND_BASE"]+"/api/services/app/ContainerReport/GetContainerClientReport"
        #puts url
        response = RestClient.get url, {:Authorization => access_token, content_type: :json, accept: :json, params: {FromDate: '2018-06-30T18:00:00.000Z', ToDate: '2018-07-31T17:59:59.999Z', AgentId: 50, MloId: 13073, CurrentDepotUnitId: 0, PermittedDepotUnitId: 0, ContainerConditionId: 0,ContainerSizeId: 0, ContainerTypeId: 0, ReportType: 3, ContainerStatus: 99, SourceId: 0, DestinationId: 0}}
        if response.code == 200
             stockinfo = JSON.parse(response.body,symbolize_names: true )
             if stockinfo[:success] == true
                #puts stockinfo[:result]
                 return stockinfo[:result]
             else
                 return nil
             end   
         else
            return nil
        end        
    end
end
