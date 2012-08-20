require 'api_doc/engine'
require 'api_doc/configuration'

module ApiDoc

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
