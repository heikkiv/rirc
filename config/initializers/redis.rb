uri = (ENV['REDISTOGO_URL']) ? URI.parse(ENV['REDISTOGO_URL']) : URI.parse('redis://localhost:6379/')
puts "Redis URL: #{uri}"
$redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
puts 'Redis connection opened'
