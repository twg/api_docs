ApiDocs::Engine.routes.draw do
  match '/(:version)' => 'api_docs/docs#index'
end