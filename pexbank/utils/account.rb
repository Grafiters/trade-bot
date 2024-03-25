require_relative './main.rb'

module Utils
    class Account < Utils::Main
        def initialize(params)
            @logger = params
        end

        def parsingBalance
            @data.select{ |b| (b[:currency] == 'eth' || b[:currency] == 'usdt') }
        end

        def balance
            balance = request('/api/v2/exchange/account/balances', 'get')
            # parsingBalance
            @data = Array.new
            balance.each do |currencies|
                @data.push({ currency: currencies[:currency], balance: currencies[:balance] })
            end

            parsingBalance
        end
    end
end