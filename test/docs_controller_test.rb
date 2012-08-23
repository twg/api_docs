require File.expand_path('test_helper', File.dirname(__FILE__))

class ApiDocs::DocsControllerTest < ActionController::TestCase
  
  def setup
    ApiDocs.config.docs_path = Rails.root.join('../../doc/api')
  end
  
  def test_get_index
    get :index
    assert_response :success
    assert assigns(:api_controllers)
    assert_template :index
  end
end
