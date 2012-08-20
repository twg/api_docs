require 'test_helper'

class ApiDoc::DocsControllerTest < ActionController::TestCase
  
  def setup
    ApiDoc.config.docs_path = Rails.root.join('../../doc/api')
  end
  
  def test_get_index
    get :index
    assert_response :success
    assert assigns(:api_controllers)
    assert_template :index
  end
end
