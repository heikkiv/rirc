puts "Redis URL: #{ENV['REDISTOGO_URL']}"
uri = URI.parse(ENV["REDISTOGO_URL"])
$redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
puts 'Redis connection opened'
