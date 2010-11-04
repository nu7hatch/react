require 'redis'
require 'daemons'

begin
  require 'fastthread' 
rescue LoadError
  $stderr.puts("The fastthread gem not found. Using standard ruby threads.")
  require 'thread'
end

module React

  require 'react/runner'
  require 'react/version'

end # React
