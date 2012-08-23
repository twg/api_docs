class ApiDocs::Configuration
  
  # Where to find the folder with documentation files
  attr_accessor :docs_path
  
  # Controller that ApiDocs::DocsController inherits from
  attr_accessor :base_controller
    
  # Configuration defaults
  def initialize
    @docs_path        = Rails.root.join('doc/api')
    @base_controller  = 'ApplicationController'
  end
end