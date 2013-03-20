require 'rest_client'

NOTIFICATION_URL = 'http://boxcar.io/devices/providers/w0HwjplsXU2ujtJCi4U1/notifications'
puts "Irc server: #{Rails.application.config.irc_server}"

$bot = Cinch::Bot.new do

  configure do |c|
    c.nick = Rails.application.config.irc_nick
    c.server = Rails.application.config.irc_server
    c.channels = Rails.application.config.irc_channels
  end

  on :message do |m|
    puts m.inspect
    if m.message == 'VERSION'
      return
    elsif m.channel?
      puts "New message in channel #{m.channel.name}"
      if m.message.downcase.index(Rails.application.config.irc_nick)
        notification = "#{m.user.name}: #{m.message}"
        RestClient.post(NOTIFICATION_URL, 'email' => 'heikki.verta@gmail.com', 'notification[message]' => notification)
      end
    else
      puts "New private message from #{m.user.name}"
      $redis.sadd('private:message:senders', m.user.name)
      notification = "PM #{m.user.name}: #{m.message}"
      RestClient.post(NOTIFICATION_URL, 'email' => 'heikki.verta@gmail.com', 'notification[message]' => notification)
    end
    msg = Message.new
    msg.channel = (m.channel) ? m.channel.name : m.user.name
    msg.sender = m.user.name
    msg.body = m.message
    Message.save(msg)
    $redis.incr('channel:' + msg.channel + ':unreadmessagecount')
  end

end

puts 'Starting ircbot in a new thread'
Thread.new do
  $bot.start
end