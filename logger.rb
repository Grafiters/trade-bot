require 'logger'

class CustomLogger < Logger
  COLORS = {
    default: "\e[0m", # Reset color
    red: "\e[31m",
    green: "\e[32m",
    yellow: "\e[33m",
    blue: "\e[34m",
    magenta: "\e[35m",
    cyan: "\e[36m"
  }

  def initialize(*args)
    super(*args)
  end

  def log_with_color(severity, message)
    color = case severity
            when 1
            COLORS[:green]
              COLORS[:green]
            when 2
              COLORS[:yellow]
            when 3
              COLORS[:red]
            when 4
              COLORS[:blue]
            else
              COLORS[:default]
            end

    print color
    "#{color}#{message}#{COLORS[:default]}"
  end

  def add_with_color(severity, message = nil, progname = nil, &block)
    message = yield if block_given?
    message = log_with_color(severity, message)
    add_without_color(severity, message, progname)
  end

  alias_method :add_without_color, :add
  alias_method :add, :add_with_color
end 