require_relative './main.rb'

module Utils
    class Order < Utils::Main
        def initialize(params)
            @logger = params
        end

        def order
            request('/api/v2/exchange/market/orders', 'get')
        end
    end
end