class GetSodmsCurrentLoginInfo
    def self.perform(options={})
        access_token = 'Bearer ' + AuthService.authenticate;
        url = ENV["LOCAL_BACKEND_BASE"]+"/api/services/app/Session/GetCurrentLoginInformations";
        response = RestClient.get url, {:Authorization => access_token, content_type: :json, accept: :json}
        login_info = JSON.parse(response.body,symbolize_names: true ) 
        if login_info[:success] == true
            return login_info[:result]
        else
            return nil
        end   
    end
end