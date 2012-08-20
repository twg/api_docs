require_dependency "api_doc/application_controller"

module ApiDoc
  class DocsController < ApiDoc::ApplicationController
    def index
      raise 'hey'
    end
  end
end
