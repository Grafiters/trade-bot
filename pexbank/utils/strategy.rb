require_relative File.join(File.dirname(__FILE__), '../','../','logger.rb')
require_relative File.join(File.dirname(__FILE__), 'account.rb')
require_relative File.join(File.dirname(__FILE__), 'market.rb')
require_relative File.join(File.dirname(__FILE__), 'trade.rb')
require_relative File.join(File.dirname(__FILE__), 'order.rb')

module Utils
    class Strategy
        def initialize
            @logger = CustomLogger.new(STDOUT)
            @account = Utils::Account.new(@logger)
            @market = Utils::Market.new(@logger)
            @order = Utils::Order.new(@logger)
            @trade = Utils::Trade.new(@logger)
        end

        def main
            # @account.balance
            # @market.market
            # @order.order
            @logger.info @trade.trade
        end
    end
end