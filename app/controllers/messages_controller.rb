class MessagesController < ApplicationController

  def show
    render :json => {:id => params[:id]}
  end

  def index
    params[:channel] ||= '#ep-dev'
    @messages = Message.list(params[:channel])
    respond_to do |format|
      format.html
      format.json { render :json => @messages }
    end
  end

end
