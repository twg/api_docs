require File.expand_path('test_helper', File.dirname(__FILE__))

class ApiDocs::DocsControllerTest < ActionController::TestCase

  def setup
    File.open(ApiDocs.config.docs_path.join('v1:test.yml'), 'w'){|f| f.write({}.to_yaml)}
  end

  def teardown
    Dir.glob(ApiDocs.config.docs_path.join('*.yml')).each do |file_path|
      FileUtils.rm(file_path)
    end
  end
  
  def test_get_index
    get :index
    assert_response :success
    assert assigns(:api_controllers)
    assert_template :index
  end

  def test_get_index_with_version
    get :index, version: "v1"
    assert_response :success
    assert_equal assigns(:api_controllers), {"v1:test"=>{}}
    assert_template :index
  end

  def test_get_index_with_non_existant_version
    get :index, version: "v2"
    assert_response :success
    assert_equal assigns(:api_controllers), {}
    assert_template :index
  end
end
