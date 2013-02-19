require 'rest_client'

NOTIFICATION_URL = 'http://boxcar.io/devices/providers/w0HwjplsXU2ujtJCi4U1/notifications'

$bot = Cinch::Bot.new do

  configure do |c|
    c.nick = 'HeikkiV'
    c.server = "irc.freenode.org"
    c.channels = ["#ep-dev-test", "#ep-dev", "#yougamers2"]
  end

  on :message do |m|
    puts m.inspect
    if m.channel?
      puts "New message in channel #{m.channel.name}"
      if m.message.downcase.index('heikkiv')
        notification = "#{m.user.name}: #{m.message}"
        RestClient.post(NOTIFICATION_URL, 'email' => 'heikki.verta@gmail.com', 'notification[message]' => notification)
      end
    else
      puts "New private message from #{m.user.name}"
      $redis.sadd('private:message:senders', m.user.name)
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
