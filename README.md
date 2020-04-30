# Json:Api Flow

## Requirements
Using this gem you still require a solution to serialize your data into something
compatible with json:api. I recommend [fast_jsonapi](https://github.com/fast-jsonapi/fast_jsonapi), but other solutions are available.

## Goal
Make it easy to add controllers and endpoints in a consistent way that is conform with the [json:api](https://jsonapi.org/) spec.
You can always take a look at the [dummy](spec/dummy/) app in specs to see a working version.

### Routes
JAF adds a few helper methods to quickly add resources in your `routes.rb`
You can find these [here](lib/jaf/routes.rb).

Example:
```ruby
Rails.application.routes.draw do
  json_api_resources :users do
    json_api_many :lists, set_relationship: true
  end

  json_api_resources :lists do
    json_api_many :todos, set_relationship: true
    json_api_one :user, set_relationship: true

    get :permissions, to: 'permissions#index'
  end

  json_api_resources :todos do
    json_api_one :list, set_relationship: true
  end
end
```

### Base
This module is to be included in your `application_controller`.
- It adds methods that based on the controller name can determine what your model class is etc. [more info](lib/jaf/base/meta.rb)
- It adds methods that help with validating. [more info](lib/jaf/base/validation.rb)
- It adds methods that can be overridden to change default behaviour. [more info](lib/jaf/base/defaults.rb)
- It adds some handy methods that can be used. [more info](lib/jaf/base.rb)

Example using fast_jsonapi serializers:
```ruby
class ApplicationController < ActionController::API
  include Jaf::Base

  def serializer
    "#{resource_model}Serializer".constantize
  end

  def serialize(resource, options = {})
    serializer.new(resource, options).serialized_json
  end

  def allowed_includes
    serializer.relationships_to_serialize.keys.map(&:to_s)
  end

  def allowed_fields
    fields = {}
    fields[resource_name] = serializer.attributes_to_serialize.keys.map(&:to_s)
    return fields unless options[:include]

    fields = options[:include].each_with_object(fields) do |included, fields|
      next fields unless allowed_includes.include?(included)

      serializer = "#{included.singularize.camelize}Serializer".constantize
      fields[included] = serializer.attributes_to_serialize.keys.map(&:to_s)
    end

    fields
  end
```

### Resources
To be included in your controllers that inherit from the `application_controller`.
Contains all the basic controller actions with the correct data flow following json:api spec.
[more info](lib/jaf/resources.rb)

Example:
```ruby
class UsersController < ApplicationController
  include Jaf::Resources

  def resource_params
    deserialized_params.permit(:name, :email)
  end
end
```

## TODO
- A good solution for relationships endpoints
- Validate filter params based on `allowed_filters`
- Allow routes helper methods to accept string and symbols for `only:` and `except:`
