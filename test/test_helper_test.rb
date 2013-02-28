require File.expand_path('test_helper', File.dirname(__FILE__))

class TestHelperTest < ActionDispatch::IntegrationTest
  
  def setup
    ApiDocs.config.ignored_attributes = %(created_at updated_at)
    Dir.glob(ApiDocs.config.docs_path.join('*.yml')).each do |file_path|
      FileUtils.rm(file_path)
    end
  end
  
  def test_api_deep_clean_params
    assert_equal ({'a' => 'b'}),
      api_deep_clean_params({:a => 'b'})
    
    assert_equal ({'a' => {'b' => 'c'}}),
      api_deep_clean_params({:a => {:b => 'c'}})
    
    assert_equal ([{'a' => 'b'}, {'c' => 'd'}]),
      api_deep_clean_params([{:a => 'b'}, {:c => 'd'}])
      
    assert_equal ({'a'=>[{'b'=>'c'}]}),
      api_deep_clean_params({:a => [{:b => 'c'}]})
  end
  
  def test_api_deep_clean_params_with_file_handler
    assert_equal ({'a' => 'BINARY'}),
      api_deep_clean_params({:a => Rack::Test::UploadedFile.new(__FILE__)})
  end
  
  def test_api_call
    api_call(:get, '/users/:id', :id => 12345, :format => 'json') do |doc|
      assert_response :success
      assert_equal ({
        'id'    => 12345,
        'name'  => 'Test User'
      }), JSON.parse(response.body)
    end
    
    api_call(:get, '/users/:id', :id => 'invalid', :format => 'json') do |doc|
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
    
    assert_equal 'ID-', output['show'].keys.first[0..2]
    
    object = output['show'][output['show'].keys.first]
    assert_equal 'GET',                                     object['method']
    assert_equal '/users/:id',                              object['path']
    assert_equal ({'id' => '12345', 'format' => 'json'}),   object['params']
    assert_equal 200,                                       object['status']
    assert_equal ({'id' => 12345, 'name' => 'Test User'}),  JSON.parse(object['body'])
    
    object = output['show'][output['show'].keys.last]
    assert_equal 'GET',                                     object['method']
    assert_equal '/users/:id',                              object['path']
    assert_equal ({'id' => 'invalid', 'format' => 'json'}), object['params']
    assert_equal 404,                                       object['status']
    assert_equal ({'message' => 'User not found'}),         JSON.parse(object['body'])
  end
  
  def test_api_call_with_ignored_attribute
    api_call(:get, '/users/:id', :id => 12345, :format => 'json') do
      assert_response :success
    end
    output = YAML.load_file(ApiDocs.config.docs_path.join('application.yml'))
    assert_equal 1, output['show'].keys.size
    
    ApiDocs.config.ignored_attributes << 'random'
    api_call(:get, '/users/:id', :id => 12345, :random => 1, :format => 'json') do
      assert_response :success
    end
    output = YAML.load_file(ApiDocs.config.docs_path.join('application.yml'))
    assert_equal 2, output['show'].keys.size
    object = output['show'][output['show'].keys.last]
    assert_not_equal 'IGNORED', object['body']['random']
    
    api_call(:get, '/users/:id', :id => 12345, :random => 1, :format => 'json') do
      assert_response :success
    end
    output = YAML.load_file(ApiDocs.config.docs_path.join('application.yml'))
    assert_equal 2, output['show'].keys.size
  end

  def test_api_call_with_xml
    api_call(:get, '/users/:id', :id => 12345, :format => 'xml') do
      assert_response :success
      xml_response = <<-eoxml
<?xml version="1.0" encoding="UTF-8"?>
<user>
  <id type="integer">12345</id>
  <name>Test User</name>
</user>
eoxml
      assert_equal xml_response, response.body
    end
    output = YAML.load_file(ApiDocs.config.docs_path.join('application.yml'))
    assert_equal 1, output['show'].keys.size
  end
  
end