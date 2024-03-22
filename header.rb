require_relative 'logger.rb'
require 'openssl'
require 'json'

class Header
    def initialize(params)
        @apikey = params[:apikey]
        @secret = params[:secret]
        @logger = CustomLogger.new(STDOUT)
    end

    def generate_signature
        {
            apikey: @apikey,
            nonce: nonce.to_s,
            signature: signature
        }
    end

    private

    def nonce
        (Time.now.to_f * 1000).to_i
    end

    def signature
        data = nonce.to_s + @apikey        
        hmac = OpenSSL::HMAC.digest('SHA256', @secret, data)
        hmac_hex = hmac.unpack1('H*')
    end
end