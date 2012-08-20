module ApiDoc
  class Configuration

    # Where to find the folder with the yaml docs
    attr_accessor :yaml_docs_folder, :api_url
        
    # Configuration defaults
    def initialize
      @yaml_docs_folder = '/doc'
      @api_url          = 'http://localhost:3000'
    end
    
  end
end