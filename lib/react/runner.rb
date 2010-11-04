module React
  class Runner
    
    class NoQueueError < RuntimeError; end
    
    attr_reader :options
    attr_reader :commands
    
    def initialize(commands_file, options)
      @options  = options
      @commands = YAML.load_file(commands_file)
      
      raise NoQueueError, "Queue have to be specified!" unless options[:queue]
    end
    
    # It starts the consumer loop. 
    def start
      puts "== Connected to #{redis.client.id}"
      puts "== Waiting for commands from `#{options[:queue]}`"
      
      if options[:daemon]
        puts "== Daemonizing..."
        Daemons.daemonize
      end
      
      loop do
        begin 
          cid = redis.blpop(options[:queue], 10)[1]
          if cmd = commands[cid.to_s]
            puts "\e[33m[#{Time.now}]\e[0m Reacting for `#{cid}` command"
            threads.add(Thread.new { system(cmd) })
          end
        rescue Interrupt, SystemExit
          puts "\nCleaning up..."
          return 0
        rescue => ex
          puts "ERROR: #{ex}"
        end
      end
    end
    
    # Returns group of executor's threads. 
    def threads
      @threads ||= ThreadGroup.new
    end
  
    # It joins all alive threads, and it's waiting till they will finish.
    def join
      threads.list.each {|t| t.join if t.alive? }
    end
  
    # Redis client instance. 
    def redis
      @redis ||= Redis.new(options[:redis].merge(:thread_safe => true))
    end
    
  end # Runner
end # React
