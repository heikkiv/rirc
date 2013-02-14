$bot = Cinch::Bot.new do

  configure do |c|
    c.nick = 'HeikkiV'
    c.server = "irc.freenode.org"
    c.channels = ["#ep-dev-test"]
  end

  on :message do |m|
    #m.reply "Hello, #{m.user.nick}"
    #Channel('#rammer-bots').msg(client.get_latest_message_id)
    puts m.inspect
    msg = Message.new
    msg.channel = m.channel.name
    msg.sender = m.user.name
    msg.body = m.message
    Message.save(msg)
  end

end

puts 'Starting ircbot in a new thread'
Thread.new do
  $bot.start
end
