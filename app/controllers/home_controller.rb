class HomeController < ApplicationController

  def index
    redirect_to :controller => "messages", :action => "index"
  end

end
