
class RetrieveCargoData
    def self.perform(options={})
        access_token = 'Bearer ' + AuthService.authenticate;
        url = ENV["LOCAL_BACKEND_BASE"]+"/api/services/app/MailReport/RetrieveCombineCargoClientReportForEmail";
        response = RestClient.post url, options.to_json, {:Authorization => access_token, content_type: :json, accept: :json}
        mailinfo = JSON.parse(response.body,symbolize_names: true ) 
        if mailinfo[:success] == true
            return mailinfo[:result]
        else
            return nil
        end   
    end
end
