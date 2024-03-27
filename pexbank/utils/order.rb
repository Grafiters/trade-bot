require_relative './main.rb'

module Utils
    class Order < Utils::Main
        def initialize(params)
            @logger = params
            @route = '/api/v2/exchange'
        end

        def order
            limit = ENV.fetch('MAXIMUM_ORDER')
            request("/api/v2/exchange/market/orders?limit=#{limit}", 'get')
        end

        def create_order(order)
            body = {
                market:   order[:market].downcase,
                side:     order[:side],
                volume:   order[:volume],
                price:    order[:price],
                ord_type: 'limit',
            }

            @logger.warn body
            response = request("#{@route}/market/orders", 'post', body)
            if !response[:errors]
                @logger.info "Create order #{response[:side]} amount #{response[:origin_volume]} price #{response[:price]} "
            else
                @logger.error response[:errors]
            end
            return response
        end

        def cancel_order(order_id)
            path = "#{@route}/market/#{order_id}/cancel"

            response = request("#{@route}/market/orders", 'post', {})
            if !response[:errors]
                @logger.info "Cancel order #{response[:id]} success"
            else
                @logger.error response[:errors]
            end

            return response
        end
    end
end