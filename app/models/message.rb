class Message
  attr_accessor :sender, :body, :channel, :created

  def initialize(data={})
    @created = (data['created']) ? Time.parse(data['created']) : Time.now
    @sender = (data['sender']) ? data['sender'] : ''
    @body = (data['body']) ? data['body'] : ''
    @channel = (data['channel']) ? data['channel'] : ''
  end

  def Message.save(message)
    key = "channel:#{message.channel}"
    $redis.zadd(key, Time.now.to_f, message.to_json)
  end

  def Message.list(channel, since=(Time.now - 60*60*24).to_f)
    messages = $redis.zrevrangebyscore("channel:#{channel}", '+inf', since)
    if messages.length > 100
      messages = messages.slice(0, 100)
    end
    messages.map do |m|
      Message.new(JSON.parse(m))
    end
  end

  def Message.private_message_senders
    $redis.smembers('private:message:senders')
  end

end
