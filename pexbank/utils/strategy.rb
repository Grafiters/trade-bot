require_relative File.join(File.dirname(__FILE__), '../','../','logger.rb')
require_relative File.join(File.dirname(__FILE__), 'account.rb')
require_relative File.join(File.dirname(__FILE__), 'market.rb')
require_relative File.join(File.dirname(__FILE__), 'trade.rb')
require_relative File.join(File.dirname(__FILE__), 'order.rb')
require 'bigdecimal'

module Utils
    class Strategy
        def initialize
            @logger = CustomLogger.new(STDOUT)
            @account = Utils::Account.new(@logger)
            @market = Utils::Market.new(@logger)
            @order = Utils::Order.new(@logger)
            @trade = Utils::Trade.new(@logger)
            @marketId = ENV.fetch("MARKET_ID")
            @marketDetail = get_market
            @price = 0.0
            @amount = 0.0
            @step = ENV.fetch('LEVEL_PRICE_STEP')
            @interval = ENV.fetch('INTERVAL').split.map { |element| element.to_f }

            update_price
        end

        def main
            order = get_order
            if order.count <= ENV.fetch('MAXIMUM_ORDER').to_i
                store_order
            else
                cancel_order(order.first)
            end
            # @logger.info "current open price is #{@price} with lowest at #{get_price[:low_price]} and highest at #{get_price[:high_price]}"
        end

        def store_order
            @order.create_order(build_order)
        end

        def cancel_order(order_id)
            @order.cancel_order(order_id)
        end

        def get_price
            {
                low_price: ENV.fetch('LOW_PRICE'),
                high_price: ENV.fetch('HIGHT_PRICE'),
                open: @price
            }
        end

        def update_price
            market = @market.market_ticker(transform_market_id)
            if !market[:errors] && market
                ENV['LOW_PRICE'] = market[:ticker][:low]
                ENV['HIGHT_PRICE'] = market[:ticker][:high]
                @price = market[:ticker][:open],
                @amount = market[:ticker][:amount]
            end
        end

        private

        def get_order
            @order.order
        end

        def transform_market_id
            return @marketId.gsub('/', '')
        end

        def transform_market_id_to_split
            return @marketId.split('/')
        end

        def price_level
            if @price.first.to_f <= 0.0
                currencies = get_currenceis
                return { amount: @marketDetail[:min_amount].to_f, price: currencies.first[:price] }
            else
                return { amount: @amount, price: @price.first }
            end
        end

        def build_order
            amount, price = strategic_price_and_amount
            {
                market: transform_market_id,
                side: %w[buy sell].sample,
                volume: amount,
                price: price
            }
        end

        def strategic_price_and_amount
            level = price_level
            price = level[:price].to_f + @interval.sample
            amount = level[:amount].to_f * (@interval.sample / 100)
            return [ amount, price ]
        end

        def get_market
            marketId = transform_market_id_to_split
            market = @market.market("?quote_unit=#{marketId[0]}&base_unit=#{marketId[1]}")
            @marketDetail = market.first
        end

        def get_currenceis
            currencies = @market.price_currencies(transform_market_id_to_split[0])
        end
    end
end