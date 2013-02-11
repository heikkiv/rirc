class MessagesController < ApplicationController

  def show
    render :json => {:id => params[:id]}
  end

  def index
    @channel = (params[:channel]) ? params[:channel] : '#ep-dev'
    @messages = Message.list(@channel)
    @private_message_senders = Message.private_message_senders
    respond_to do |format|
      format.html
      format.json { render :json => @messages }
    end
  end

  def create
    @m = Message.new(params)
    Message.save(@m)
    redirect_to :action => "index", :channel => params[:channel]
  end

end
