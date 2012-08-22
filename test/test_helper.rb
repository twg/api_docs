# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!

class ActionController::TestCase
  setup :use_engine_routes
  def use_engine_routes
    @routes = ApiDocs::Engine.routes
  end
end
