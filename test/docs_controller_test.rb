require File.expand_path('test_helper', File.dirname(__FILE__))

class ApiDocs::DocsControllerTest < ActionController::TestCase
  
  def test_get_index
    get :index
    assert_response :success
    assert assigns(:api_controllers)
    assert_template :index
  end
end
