class MessagesController < ApplicationController

  before_filter :require_login

  def show
    render :json => {:id => params[:id]}
  end

  def index
    @channel = (params[:channel]) ? params[:channel] : '#ep-dev'
    @since = (params[:since]) ? params[:since].to_f : 0
    @messages = Message.list(@channel, @since)
    @users = []
    if @channel.start_with?('#') && $bot.Channel(@channel)
      @users = $bot.Channel(@channel).users.keys
    end

    @private_message_senders = get_private_message_senders
    @unread_messages_ep_dev = $redis.get('channel:#ep-dev:unreadmessagecount').to_i
    @unread_messages_ep_dev_test = $redis.get('channel:#ep-dev-test:unreadmessagecount').to_i
    @unread_messages_yougamers = $redis.get('channel:#yougamers2:unreadmessagecount').to_i

    @current_channel_unread_messages = $redis.get('channel:' + @channel + ':unreadmessagecount').to_i
    $redis.set('channel:' + @channel + ':unreadmessagecount', '0') unless params[:no_reset]

    puts "#{@current_channel_unread_messages} unread messages in channel #{@channel}"

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

  private

  def get_private_message_senders
    senders = Message.private_message_senders
    senders.map do |sender|
      {
        :sender => sender,
        :unread_messages => $redis.get('channel:' + sender + ':unreadmessagecount').to_i
      }
    end
  end

end
