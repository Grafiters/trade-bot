require 'dotenv/load'

require_relative 'logger.rb'
require_relative 'header.rb'
require_relative 'client.rb'

@logger = CustomLogger.new(STDOUT)

def generateHeader
    key = {
        apikey: ENV['APIKEY'],
        secret: ENV['SECRET']
    }

    Header.new(key).generate_signature
end

def parsingBalance
    @balance.select{ |b| (b[:currency] == 'eth' || b[:currency] == 'usdt') }
end

def main
    header = generateHeader
    @client = Client.new({header: header})

    @balance = @client.get('/api/v2/exchange/account/balances')
    @logger.info parsingBalance
end

main()