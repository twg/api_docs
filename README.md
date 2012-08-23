# API docs
A tool to help you generate documentation for you API using integration tests in Rails 3.


## Installation
Add gem definition to your Gemfile and `bundle install`:
    
    gem 'api_docs'
    
To access generated docs mount it to a path in your `routes.rb` like this:

    mount ApiDocs::Engine => '/api-docs'

Add [Twitter bootstrap](http://twitter.github.com/bootstrap) and [Google code pretifyer](http://google-code-prettify.googlecode.com/svn/trunk/README.html) to you CSS manifest file

``` js
//= require bootstrap
//= require prettify
```

Here's what you Javascript manifest file should look like

``` js
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require prettify
//= require api_docs
```

Add your API documentation files to the /doc/api folder and in your view do:

``` ruby
= render_api_docs %w{login users overview}
```

## The API documentation files
  
Here's a sample API for users

``` yaml
'List':
  url: '/users'
  method: GET
  description: Returns a list of users
  params:
    api_key:
    keyword: "a string of one or more words used to filter the users by first_name, last_name and email (optional)"
  success:
    response: 'HTTP/1.1 200 OK'
    data: |
      {
        "users": [
          {
            "id": 27,
            "first_name": "John",
            "last_name": "Smith",
            "created_at": "2011-06-13T00:28:36-04:00",
            "updated_at": "2012-04-26T20:21:43-04:00"
          },
          {
            "id": 3,
            "first_name": "Anna",
            "last_name": "Brown",
            "created_at": "2011-06-13T00:28:36-04:00",
            "updated_at": "2012-04-26T20:21:43-04:00"
          },
          ...
        ]
      }
  fail:
    response: 'HTTP/1.1 422 Unprocessable Entity'
    data: |
      {
        "message": "Failed to create User",
        "errors" : {
          "email": "Email is invalid",
          ...
        }
      }

  curl: curl -i :api_url/users?api_key=7gR9hZt3DBqcuzi2mZKN

# ------------------------------

'Show':
  url: '/users/:id'
  method: GET
  description: |
    Returns profile details for a specified user.
    <span class=label>NOTE</span> If showing details of another user the email is ommited
  params:
    api_key:
    id: the id of a user
  success:
    response: 'HTTP/1.1 200 OK'
    data: |
      {
        "user": {
          "id": 917,
          "api_key": "7gR9hZt3DBqcuzi2mZKN",
          "email": "john_smith@gmail.com",
          "first_name": "John",
          "last_name": "Smith",
          "created_at": "2011-06-13T00:28:36-04:00",
          "updated_at": "2012-04-26T20:21:43-04:00"
        }
      }
  fail:
    response: 'HTTP/1.1 404 Not Found'
    data: |
      {
        "message": "User not found"
      }
  curl: curl -i :api_url/users/197?api_key=2a10K5ipBd2qapJsPvCso90kMO

# ------------------------------

'Create':
  url: '/users'
  method: POST
  description: Create a user
  params:
    user[first_name]:
    user[last_name]:
    user[email]:
    user[password]:
  success:
    response: 'HTTP/1.1 201 Created'
    data: |
      {
        "user": {
          "id": 917,
          "api_key": "7gR9hZt3DBqcuzi2mZKN",
          "email": "john_smith@gmail.com",
          "first_name": "John",
          "last_name": "Smith",
          "created_at": "2011-06-13T00:28:36-04:00",
          "updated_at": "2012-04-26T20:21:43-04:00"
        }
      }
  fail:
    response: 'HTTP/1.1 422 Unprocessable Entity'
    data: |
      {
        "message": "Failed to create User",
        "errors" : {
          "email": "Email is invalid",
          ...
        }
      }
  curl: |
    curl -i :api_url/v1/users \
      -d "user[first_name]=John" \
      -d "user[last_name]=Smith" \
      -d "user[email]=john_smith@twg.ca" \
      -d "user[password]=passpass"
```


## Configuration

You can change the default configuration of this gem by adding the following code to your initializers folder:

``` ruby
ApiDocs.configure do |config|
  config.yaml_docs_folder = '/some/other/folder ' # the default folder is /doc/api
end
```


---

Copyright 2012 Jack Neto, [The Working Group, Inc](http://www.theworkinggroup.ca)

