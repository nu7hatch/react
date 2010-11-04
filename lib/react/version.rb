module React
  module Version # :nodoc:
    MAJOR  = 0
    MINOR  = 1
    PATCH  = 0
    STRING = [MAJOR, MINOR, PATCH].join('.')
  end
  
  def self.version # :nodoc:
    Version::STRING
  end
end # React
