begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name        = 'api_docs'
    gem.homepage    = 'http://github.com/twg/api_docs'
    gem.license     = 'MIT'
    gem.summary     = 'Generate API documentation using integration tests in Ruby on Rails 3'
    gem.description = 'Generate API documentation using integration tests in Ruby on Rails 3'
    gem.email       = 'jack@twg.ca'
    gem.authors     = ['Oleg Khabarov', 'Jack Neto', 'The Working Group Inc.']
  end
  Jeweler::RubygemsDotOrgTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end


require 'rake/testtask'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end
task :default => :test