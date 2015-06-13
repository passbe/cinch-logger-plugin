class LoggerPlugin

    # Mark as Cinch plugin
    include Cinch::Plugin

    # Defines how many retries to open a file before failing
    ERROR_LIMIT = 3

    # Set a timer to read log file
    timer 5, method: :tail

    def initialize(*args)
        super
        open
        @count = 0
    end

    # Open the file
    def open
        begin
            @file = File.open(config[:log], "r")
            @file.seek(0,IO::SEEK_END)
            @count = 0
            return true
        rescue StandardError => e
            error "Unable to monitor file: #{config[:log]} with error #{e.message}."
            @file.close if not @file.nil?
        end
        return false
    end

    # Check the existence of the file and if we currently have it open
    def exists_and_open?
        File.exists?(config[:log]) and not @file.nil? and not @file.closed?
    end

    # Read new file lines and output
    def tail
        if exists_and_open?
            # Output new lines
            @file.readlines.each{|l| output(l) }
        else
            # Try open it again
            if not open
                output("[ERROR] Unable to open log file: #{config[:log]}.") if @count != LoggerPlugin::ERROR_LIMIT
                destroy
            end
        end
    end

    # Output message to all configured channels
    def output(msg)
        config[:channels].each{|c| Channel(c).send(msg) }
    end

    # Destroy timers
    # Note: Allow bot to output error message until LoggerPlugin::ERROR_LIMIT is reached
    def destroy
        @count += 1
        if @count > LoggerPlugin::ERROR_LIMIT
            output("[FATAL] Stopped monitoring: #{config[:log]}.")
            @file.nil?timers.each{|t| t.stop }
        end
    end

end
