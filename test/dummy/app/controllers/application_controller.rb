class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def show
    status = :ok
    
    if (id = params.delete(:id)).to_i > 0
      response = {:id => id.to_i, :name => 'Test User'}
    else
      response = {:message => 'User not found'}
      status = :not_found
    end
    
    response.merge!(:random => rand) if params[:random]
    render :text => response.to_json, :status => status
  end
end
