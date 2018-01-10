require 'rest-client'

class AuthService
   def self.authenticate(options={})
        response = RestClient.post ENV["SODMS_BACKEND_BASE"]+"/api/TokenAuth/Authenticate", {  "userNameOrEmailAddress": "rokan",
           "password": "123456",  "rememberClient": true,}.to_json, {content_type: :json, accept: :json}
        authinfo = JSON.parse(response.body,symbolize_names: true )

        if authinfo[:success] == true
            return authinfo[:result][:accessToken]
        else
            return nil
        end   
    end
end