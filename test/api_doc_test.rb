require File.expand_path('test_helper', File.dirname(__FILE__))

class ApiDocTest < ActiveSupport::TestCase
  
  def test_truth
    assert_kind_of Module, ApiDoc
  end
  
  def test_configuration_defaults
    assert config = ApiDoc.configuration
    assert config.docs_path
  end
end
