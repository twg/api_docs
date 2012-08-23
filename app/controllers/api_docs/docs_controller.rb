class ApiDocs::DocsController < ApplicationController
  def index
    @api_controllers = { }
    Dir.glob(ApiDocs.config.docs_path.join('*.yml')).each do |file_path|
      @api_controllers[File.basename(file_path, '.yml')] = YAML.load_file(file_path)
    end
  end
end
