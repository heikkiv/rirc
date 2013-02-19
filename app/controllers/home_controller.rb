class HomeController < ApplicationController

  def index
    redirect_to :controller => "messages", :action => "index"
  end

  def test
    render :inline => 'OK'
  end

end
