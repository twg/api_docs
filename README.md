# API docs
A tool to help you generate documentation for you API using integration tests in Rails 3.


## Installation
Add gem definition to your Gemfile and `bundle install`:
    
    gem 'api_docs'
    
To access generated docs mount it to a path in your `routes.rb` like this:

    mount ApiDocs::Engine => '/api-docs'
    
You may also want to add js/css to your application asset pipeline manifest:
in `application.js`

    //= require api_docs
    
in `application.css`
    
    *= require api_docs
    
Documents view is made to work with [Twitter Bootstrap](http://twitter.github.com/bootstrap) css and js libraries.

## Generating Api Docs


## Configuration

You can change the default configuration of this gem by adding the following code to your initializers folder:

``` ruby
ApiDocs.configure do |config|
  config.docs_path = Rails.root.join('doc/api')
end
```

---

Copyright 2012 Oleg Khabarov, Jack Neto, [The Working Group, Inc](http://twg.ca)

