class ApiDocs::Configuration
  
  # Where to find the folder with documentation files
  attr_accessor :docs_path
    
  # Configuration defaults
  def initialize
    @docs_path = Rails.root.join('doc/api')
  end
end