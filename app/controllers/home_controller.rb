class HomeController < ApplicationController

  layout 'user'

  before_filter :login_required

  def show
    
  end


end
