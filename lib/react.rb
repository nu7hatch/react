require 'redis'
require 'thread'

# React is a simple application that allows for remote execution of commands.
# It uses Redis as a queue - it is blocking specified list and waits for new 
# entries - when an entry appears, then it is executing recognized command.
#
# == Inspiration
#
# It's inspired by Simon Willson's example of "Queue-activated shell scripts"
# in his redis-tutorial:
#
#   while [ 1 ] do
#     redis-cli blpop restart-httpd 0
#     apache2ctl graceful
#   done
#
# == Examples
# 
# Firs you have to prepare file with available commands. It can look like this: 
#
#   # my_commands.yml
#   restart_httpd: |
#     apache2ctl graceful
#   restart_mysql: |
#     /etc/init.d/mysql restart
#   reboot: |
#     reboot
#    
# Now you can start consumer. 
#
#   react my_commands.yml
#
# == Commands
#
# While your consumer is working, you can push any command to it's queue
# (default queue name is `queue`), eg:
#
#   redis-cli lpush queue restart_httpd
#   redis-cli lpush queue reboot
#
# == Configuration
#   
# There are few more runtime options, which can be useful for you. 
#   
#   # it will be consuming commands from specified queue
#   react my_commands.yml --queue "my:queue:name"
#
#   # you can specify the database to which React should connect
#   react my_commands.yml --host "yourhost.com" --port 6379 --db 2
#
#   # and finally, you can demonize your application
#   react  my_commands.yml --daemonize
module React

  # It starts the consumer loop. 
  def self.start(conf)
    @config = conf
    
    puts "== Connected to #{redis.client.id}"
    puts "== Waiting for commands from `#{@config[:queue]}`"
    
    if @config[:daemon]
      puts "== Daemonizing..."
      Daemons.daemonize
    end
    
    loop do
      begin 
        cid = redis.blpop(@config[:queue], 0)[1]
        if cmd = @config[:commands][cid.to_s]
          puts "\e[33m[#{Time.now}]\e[0m Reacting for `#{cid}` command"
          threads.add(Thread.new { system(cmd) })
        end
      rescue Interrupt
        puts "\nCleaning up..."
        break
      rescue Exception => ex
        puts "ERROR: #{ex}"
      end
    end
    
    self
  end
  
  # Returns group of executor threads. 
  def self.threads
    @threads ||= ThreadGroup.new
  end
  
  # It joins all alive threads, and it's waiting till they will finish.
  def self.join
    threads.list.each {|t| t.join if t.alive? }
  end
  
  # Redis client instance. 
  def self.redis
    @redis ||= Redis.new(@config[:redis])
  end
  
end # React