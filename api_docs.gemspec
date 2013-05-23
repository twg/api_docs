# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'api_docs/version'

Gem::Specification.new do |s|
  s.name          = "api_docs"
  s.version       = ApiDocs::VERSION
  s.authors       = ["Oleg Khabarov"]
  s.email         = ["oleg@khabarov.ca"]
  s.homepage      = "http://github.com/twg/api_docs"
  s.summary       = "Generate API documentation using integration tests in Ruby on Rails"
  s.description   = "Generate API documentation using integration tests in Ruby on Rails"
  
  s.files         = `git ls-files`.split("\n")
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
  
  s.add_dependency 'rails', '>=3.1.0'
end