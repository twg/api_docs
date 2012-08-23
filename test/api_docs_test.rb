require File.expand_path('test_helper', File.dirname(__FILE__))

class ApiDocsTest < ActiveSupport::TestCase
  
  def test_truth
    assert_kind_of Module, ApiDocs
  end
  
  def test_configuration_defaults
    assert config = ApiDocs.configuration
    assert config.docs_path
    assert_equal 'ApplicationController', config.base_controller
  end
end
