require 'api_docs/version'
require 'api_docs/engine'
require 'api_docs/configuration'
require 'api_docs/test_helper'

module ApiDocs

  class << self
    
    def configure
      yield configuration
    end
    
    def configuration
      @configuration ||= Configuration.new
    end
    alias :config :configuration
    
  end
end
