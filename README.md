# api_docs
A tool to help you generate documentation for you API using integration tests in Rails 3.


## Installation
Add gem definition to your Gemfile and `bundle install`:
    
    gem 'api_docs'
    
To access generated docs mount it to a path in your `routes.rb` like this:

    mount ApiDocs::Engine => '/api-docs'
    
You may also want to add js/css to your asset pipeline manifests:
  
    require api_docs
    
Documents view is made to work with [Twitter Bootstrap](http://twitter.github.com/bootstrap) css and js libraries.

## Generating Api Docs
Documentation is automatically generated into yaml files from tests you create to test your api controllers. To start, let's create integration test by running `rails g integration_test users`. This will create a file for you to work with. Here's a simple test we can do:

``` ruby
def test_get_user
  api_call(:get, '/users/:id', :id => @user.to_param) do |doc|
    assert_response :success
    assert_equal ({
      'id'    => @user.id,
      'name'  => @user.name
    }), JSON.parse(response.body)
  end
end

def test_get_user_failure
  api_call(:get, '/users/:id', :id => 'invalid') do |doc|
    doc.description = 'When bad user id is passed'
    assert_response :not_found
    assert_equal ({
      'message' => 'User not found'
    }), JSON.parse(response.body)
  end
end
```

Assuming that tests pass their details are doing to be recorded into `docs/api/users.yml` and they will look like this:

``` yaml
show:
  1YGvw8qQDy0Te4oEAxFdTEiS3eQ=:
    method: GET
    path: /users/:id
    params:
      id: 12345
    status: 200
    body:
      id: 12345
      name: John Doe
  YaEdGJRDZy0nsljmpJmOtcLxdUg=:
    description: When bad user id is passed
    method: GET
    path: /users/:id
    params:
      id: invalid
    status: 404
    body:
      message: User not found
```

## Configuration

You can change the default configuration of this gem by adding the following code to your initializers folder:

``` ruby
ApiDocs.configure do |config|
  config.docs_path = Rails.root.join('doc/api')
end
```

---

Copyright 2012 Oleg Khabarov, Jack Neto, [The Working Group, Inc](http://twg.ca)

