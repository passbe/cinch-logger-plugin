# Cinch Logging Plugin

I originally created this plugin for the purpose of monitoring log files with an IRC bot. See [this post](http://passbe.com/2015/06/18/monitoring-your-gateway-with-syslog-and-irc.html) for more information.

## Features
- Outputs lines from log file
- Supports multiple channels
- Can detect when log file is unreadable or missing

## Limitations
- Only watches one file
- Doesn't parse log messages

### Example Cinch bot code

```ruby
require 'cinch'
require_relative 'logger_plugin'

bot = Cinch::Bot.new do

  configure do |c|
    c.server = "127.0.0.1"
    c.nick = "logger"
    c.channels = ["#logs"]
    c.plugins.plugins = [LoggerPlugin]
    c.plugins.options[LoggerPlugin] = {
      log: "/var/log/file.log",
      channels: c.channels
    }
  end

end

bot.start
```

Let me know if you've found it useful!
