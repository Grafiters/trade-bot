require_relative './main.rb'

module Utils
    class Market < Utils::Main
        def initialize(params)
            @logger = params
            @route = '/api/v2/exchange'
        end

        def market(query = '')
            request("/api/v2/exchange/public/markets#{query}", 'get')
        end

        def price_currencies(query = '')
            request("/api/v2/exchange/public/currencies?search[code]=#{query}", 'get')
        end

        def market_ticker(market_id)
            path = "#{@route}/public/markets/#{market_id}/tickers"
            response = request(path, 'get')
            if response[:errors]
                @logger.error response[:errors]
            end

            return response
        end
    end
end