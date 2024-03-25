require_relative './main.rb'

module Utils
    class Market < Utils::Main
        def initialize(params)
            @logger = params
        end

        def market
            request('/api/v2/exchange/public/markets', 'get')
        end
    end
end
