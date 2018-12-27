require 'rest-client'

class AuthService
      @@expiredAt = Time.now;
      @@accessToken = nil;

   def self.authenticate(options={}) 
        if Time.now < @@expiredAt and  !@@accessToken.nil?
           return @@accessToken
        else   
            puts "Calling SODMS backend to authenticate"
            puts "#{ENV["LOCAL_BACKEND_BASE"]}/api/TokenAuth/Authenticate}"
            response = RestClient.post ENV["LOCAL_BACKEND_BASE"]+"/api/TokenAuth/Authenticate", {  "userNameOrEmailAddress": "mailadmin",
            "password": "1234@mailer",  "rememberClient": true,}.to_json, {content_type: :json, accept: :json}
            authinfo = JSON.parse(response.body,symbolize_names: true )
            @@expiredAt =  Time.now + authinfo[:result][:expireInSeconds];
            @@accessToken = authinfo[:result][:accessToken] 
            if authinfo[:success] == true 
                return authinfo[:result][:accessToken]
            else
                return nil
            end
         end    
    end
end