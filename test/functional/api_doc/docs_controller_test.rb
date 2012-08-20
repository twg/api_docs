require 'test_helper'

class ApiDoc::DocsControllerTest < ActionController::TestCase
  
  def test_get_index
    get :index
    assert_response :success
  end
end
