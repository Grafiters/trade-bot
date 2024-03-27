require_relative File.join(File.dirname(__FILE__), '../','../','logger.rb')
require_relative "utils/strategy.rb"

if ARGV.empty?
    puts "Usage: ruby main.rb <argument>"
end

def stop
    @running = false
    sleep(10)
    @running = true
end

def main
    @logger = CustomLogger.new(STDOUT)
    @running = true

    @logger.info "Start Runner"
    begin
        Utils.const_get(ARGV[0].capitalize.to_sym).new.main()
        sleep(0)
    rescue => e
        @running = false
        @logger.error "Error : #{e.inspect}"
        @logger.error "Runner Error Restart 10 second to start again"
        stop
    end while @running
end

main()