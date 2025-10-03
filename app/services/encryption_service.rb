require 'jwt'

class EncryptionService
    attr_reader :rsa_private_key, :rsa_public_key

   def initialize
      @rsa_private_key = OpenSSL::PKey::RSA.generate 2048
      @rsa_public_key = @rsa_private_key.public_key
   end
   
   
   def rsa_encode(payload={})
     JWT.encode payload, rsa_private_key, 'RS256'
   end

   def rsa_decode(token)
     JWT.decode token, rsa_public_key, true, { algorithm: 'RS256' }
   end

   def encode(options)
     JWT.encode options[:payload], options[:hmac_secret], 'HS256'
   end

   def decode(options)
     JWT.decode options[:token], options[:hmac_secret], true, { algorithm: 'HS256' }
   end


    def self.sign(payload, options={})
     options[:key] = ENV["SECRET_KEY_BASE"] unless options.has_key? :key
     JWT.encode payload, options[:key], 'HS256'
   end

   def self.verify(token, options={})
     options[:key] = ENV["SECRET_KEY_BASE"] unless options.has_key? :key
     JWT.decode token, options[:key], true, { algorithm: 'HS256' }
   end
end