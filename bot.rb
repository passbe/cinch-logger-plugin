require 'rubygems'
require 'bundler/setup'

require 'cinch'
require_relative 'logger_plugin'

bot = Cinch::Bot.new do

    configure do |c|
        c.server = "127.0.0.1"
        c.nick = "logger"
        c.channels = ["#logs"]
        c.plugins.plugins = [LoggerPlugin]
        c.plugins.options[LoggerPlugin] = {
            log: "/var/log/example.log",
            channels: c.channels
        }
    end

end

bot.start
