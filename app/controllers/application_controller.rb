class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ActionController::HttpAuthentication::Token::ControllerMethods
  #protect_from_forgery with: :exception
   

   def authenticate
      authenticate_or_request_with_http_token do |token, options|
        # Compare the tokens in a time-constant manner, to mitigate
        # timing attacks.
          options = {:token=> token, :hmac_secret=>"thisisreallytoughy"}
           decoded_token = EncryptionService.verify token, options
            t = decoded_token[0].symbolize_keys 
            #  if decoded_token[0]
                        puts decoded_token[0]
                        if decoded_token[0]["payload"] == ENV["TOKEN"]
                            return true
                        else
                            render_unauthorized
                        end
            #  end
       #ActiveSupport::SecurityUtils.secure_compare(decoded_token[0][:payload], TOKEN)
      end
    end

    def render_unauthorized
      render json: {:errors=>'Bad Credentials', status:401 }
    end
end
