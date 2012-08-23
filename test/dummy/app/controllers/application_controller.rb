class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def show
    if (id = params[:id].to_i) > 0
      render :text => {:id => id, :name => 'Test User'}.to_json
    else
      render :text => {:message => 'User not found'}.to_json, :status => :not_found
    end
  end
end
