require_relative './main.rb'

module Utils
    class Trade < Utils::Main
        def initialize(params)
            @logger = params
        end

        def trade
            request('/api/v2/exchange/market/trades', 'get')
        end
    end
end