require 'optitron'

module React
  class CLI < Optitron::CLI
  
    desc "Show used React version"
    def version
      puts "React v#{React.version}"
    end
  
    desc "Run react executor"
    opt 'queue',    'Specify quehe which will be consumed', :short_name => 'q'
    opt 'host',     'Specify redis host',                   :short_name => 'h', :default => 'localhost'
    opt 'port',     'Specify redis port',                   :short_name => 'p', :default => 6379
    opt 'db',       'Specify redis database number',        :short_name => 'D', :default => 0
    opt 'password', 'Specify password to redis database',   :short_name => 'P', :default => nil
    opt 'daemon',   'Run in background',                    :short_name => 'd', :default => false
    def start(file)
      params[:redis] ||= {
        :host     => params.delete(:host),
        :port     => params.delete(:port),
        :db       => params.delete(:db),
        :password => params.delete(:password), 
      }
      Runner.new(file, params).start
    rescue => ex
      puts "ERROR: #{ex.to_s}"
      exit 1
    end
    
  end # CLI
end # React
