class ApplicationController < ActionController::Base
  
  http_basic_authenticate_with :name => 'user', :password => 'secret', :only => :authenticate
  
  def show
    status = :ok
    
    if (id = params.delete(:id)).to_i > 0
      response = {:id => id.to_i, :name => 'Test User'}
    else
      response = {:message => 'User not found'}
      status = :not_found
    end
    
    response.merge!(:created_at => rand.days.ago) if params[:random]
    
    respond_to do |format|
      format.json do
        render :text => response.to_json, :status => status
      end
      format.xml do
        render :text => response.to_xml(:root => 'user'), :status => status
      end
    end
  end
  
  def authenticate
    render :text => {:message => 'Authenticated'}.to_json
  end
end
