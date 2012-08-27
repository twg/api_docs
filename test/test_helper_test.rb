require File.expand_path('test_helper', File.dirname(__FILE__))

class TestHelperTest < ActionDispatch::IntegrationTest
  
  def setup
    ApiDocs.config.ignored_attributes = %(created_at updated_at)
    Dir.glob(ApiDocs.config.docs_path.join('*.yml')).each do |file_path|
      FileUtils.rm(file_path)
    end
  end
  
  def test_api_call
    api_call(:get, '/users/:id', :id => 12345) do |doc|
      assert_response :success
      assert_equal ({
        'id'    => 12345,
        'name'  => 'Test User'
      }), JSON.parse(response.body)
    end
    
    api_call(:get, '/users/:id', :id => 'invalid') do |doc|
      doc.description = 'Invalid user id'
      assert_response :not_found
      assert_equal ({
        'message' => 'User not found'
      }), JSON.parse(response.body)
    end
    
    output = begin
      YAML.load_file(ApiDocs.config.docs_path.join('application.yml'))
    rescue
      fail 'api doc file not written'
    end
    
    assert output['show'].present?
    assert_equal 2, output['show'].keys.size
    
    object = output['show'][output['show'].keys.first]
    assert_equal 'GET',                                     object['method']
    assert_equal '/users/:id',                              object['path']
    assert_equal ({'id' => '12345'}),                       object['params']
    assert_equal 200,                                       object['status']
    assert_equal ({'id' => 12345, 'name' => 'Test User'}),  object['body']
    
    object = output['show'][output['show'].keys.last]
    assert_equal 'GET',                             object['method']
    assert_equal '/users/:id',                      object['path']
    assert_equal ({'id' => 'invalid'}),             object['params']
    assert_equal 404,                               object['status']
    assert_equal ({'message' => 'User not found'}), object['body']
  end
  
  def test_api_call_with_ignored_attribute
    api_call(:get, '/users/:id', :id => 12345) do
      assert_response :success
    end
    output = YAML.load_file(ApiDocs.config.docs_path.join('application.yml'))
    assert_equal 1, output['show'].keys.size
    
    ApiDocs.config.ignored_attributes << 'random'
    api_call(:get, '/users/:id', :id => 12345, :random => 1) do
      assert_response :success
    end
    output = YAML.load_file(ApiDocs.config.docs_path.join('application.yml'))
    assert_equal 2, output['show'].keys.size
    object = output['show'][output['show'].keys.last]
    assert_not_equal 'IGNORED', object['body']['random']
    
    api_call(:get, '/users/:id', :id => 12345, :random => 1) do
      assert_response :success
    end
    output = YAML.load_file(ApiDocs.config.docs_path.join('application.yml'))
    assert_equal 2, output['show'].keys.size
  end
  
end