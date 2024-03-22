require_relative 'logger.rb'
require 'dotenv/load'
require 'faraday'

class Client
    def initialize(params)
        @host = ENV['HOST']
        @header = params[:header]
        @logger = CustomLogger.new(STDOUT)
        connection
    end

    def get(path)
        response = @connection.get \
            path
        
        return JSON.parse(response.body, symbolize_names: true)
    rescue => e
        @logger.error(e)    
    end

    def post(path, body = {})
        response = @connection.post(path) do |req|
            req.body = body.to_json
        end

        return JSON.parse(response.body, symbolize_names: true)
    rescue => e
        @logger.error(e)
    end

    private

    def connection
        @connection = Faraday.new(url: @host) do |faraday|
            faraday.headers['accept'] = 'application/json'
            faraday.headers['Content-Type'] = 'application/json'
            faraday.headers['X-Auth-Apikey'] = @header[:apikey]
            faraday.headers['X-Auth-Nonce'] = @header[:nonce]
            faraday.headers['X-Auth-Signature'] = @header[:signature]
            faraday.adapter Faraday.default_adapter
        end
    end
end