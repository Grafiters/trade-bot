require 'dotenv/load'

require_relative File.join(File.dirname(__FILE__), '../','../','logger.rb')
require_relative File.join(File.dirname(__FILE__), '../','../','client.rb')
require_relative 'header.rb'

module Utils
    class Main
        def initialize()
            @logger = CustomLogger.new(STDOUT)
        end

        def generateHeader
            key = {
                apikey: ENV['APIKEY'],
                secret: ENV['SECRET']
            }

            Header.new(key).generate_signature
        end

        def request(path, method, params = {})
            case method
            when 'get'
                Client.new({header: generateHeader}).get(path)
            when 'post'
                Client.new({header: generateHeader}).post(path)
            else
                @logger.error "No case with this method"
            end
        end
    end
end