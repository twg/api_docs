require File.expand_path('test_helper', File.dirname(__FILE__))

class ApiDocsTest < ActiveSupport::TestCase
  
  def test_truth
    assert_kind_of Module, ApiDocs
  end
  
  def test_configuration_defaults
    assert config = ApiDocs.configuration
    assert config.docs_path
    assert_equal 'ApplicationController', config.base_controller
    assert_equal %w(created_at updated_at), config.ignored_attributes
    assert_equal false, config.reload_docs_folder
  end
end
