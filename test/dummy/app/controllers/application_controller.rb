class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def index
    respond_to do |format|
      format.json {
        render :text => [{
          :id         => 1,
          :name       => 'Test User',
          :created_at => 1.day.ago
        }].to_json
      }
      format.xml {
        render :text => [{
          :id         => 1,
          :name       => 'Test User',
          :created_at => 1.day.ago
        }].to_xml(root: "users")
      }
    end
  end
  
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
      format.json { render :text => response.to_json, :status => status }
      format.xml { render :text => response.to_xml(:root => "user"), :status => status }
    end
  end
end
