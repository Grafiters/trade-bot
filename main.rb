require_relative 'logger.rb'
require_relative 'header.rb'
require_relative 'client.rb'

@logger = CustomLogger.new(STDOUT)

def generateHeader
    key = {
        apikey: '000c6242935ff9ce',
        secret: '6ca422145ac7e67860fab71906e4ee19'
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