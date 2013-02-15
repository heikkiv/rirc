class MessagesController < ApplicationController

  def show
    render :json => {:id => params[:id]}
  end

  def index
    @channel = (params[:channel]) ? params[:channel] : '#ep-dev'
    @messages = Message.list(@channel)
    @private_message_senders = Message.private_message_senders
    unreadMessages = $redis.get('channel:' + @channel + ':unreadmessagecount')
    $redis.set('channel:' + @channel + ':unreadmessagecount', '0')
    puts "#{unreadMessages} unread messages in channel #{@channel}"
    respond_to do |format|
      format.html
      format.json { render :json => @messages }
    end
  end

  def create
    channel = params['channel']
    @m = Message.new(params)
    $bot.Channel(channel).msg(@m.body)
    Message.save(@m)
    $redis.incr('channel:' + channel + ':messagecount')
    $redis.incr('channel:' + channel + ':unreadmessagecount')
    puts "Sent message to #{channel}"
    redirect_to :action => "index", :channel => params[:channel]
  end

end
