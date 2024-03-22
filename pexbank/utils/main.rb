require 'dotenv/load'

require_relative File.join(File.dirname(__FILE__), '../','../','logger.rb')
require_relative File.join(File.dirname(__FILE__), '../','../','client.rb')
require_relative 'header.rb'

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

def balance
    @balance = @client.get('/api/v2/exchange/account/balances')
end

def market
    @market = @client.get('/api/v2/exchange/public/markets?base_unit=eth&quote_unit=usdt')
end

def main
    header = generateHeader
    @client = Client.new({header: header})
    balance
    market

    @logger.info @market
end