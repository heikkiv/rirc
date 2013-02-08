class HomeController < ApplicationController

  def index
  end

  def message_count
    render :json => { :count => 0 }
  end

end
