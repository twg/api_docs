Rails.application.routes.draw do
  mount ApiDoc::Engine => "/"
end
