# Jaf
Offering libraries to help you build [JSON:API](https://jsonapi.org) compliant endpoints.

## Usage
### Create routes
in your `confit/routes.rb` you can create all needed endpoints with `json_api_resources`:
```ruby
Rails.application.routes.draw do
  # ...
  json_api_resources :lists, todos: :to_many, user: :to_one
end
```

this will give you:
```
                           list_todos GET    /lists/:list_id/todos(.:format)                                                          lists/todos#index
                                      POST   /lists/:list_id/todos(.:format)                                                          lists/todos#create
                            list_todo GET    /lists/:list_id/todos/:id(.:format)                                                      lists/todos#show
                                      PATCH  /lists/:list_id/todos/:id(.:format)                                                      lists/todos#update
                                      PUT    /lists/:list_id/todos/:id(.:format)                                                      lists/todos#update
                                      DELETE /lists/:list_id/todos/:id(.:format)                                                      lists/todos#destroy
                            list_user GET    /lists/:list_id/user(.:format)                                                           lists/users#show
                                      PATCH  /lists/:list_id/user(.:format)                                                           lists/users#update
                                      PUT    /lists/:list_id/user(.:format)                                                           lists/users#update
                                      DELETE /lists/:list_id/user(.:format)                                                           lists/users#destroy
             list_relationships_todos POST   /lists/:list_id/relationships/todos(.:format)                                            lists/relationships/todos#create
                                      PUT    /lists/:list_id/relationships/todos(.:format)                                            lists/relationships/todos#update
                                      PATCH  /lists/:list_id/relationships/todos(.:format)                                            lists/relationships/todos#update
                                      DELETE /lists/:list_id/relationships/todos(.:format)                                            lists/relationships/todos#destroy
              list_relationships_user PATCH  /lists/:list_id/relationships/user(.:format)                                             lists/relationships/users#update
                                      PUT    /lists/:list_id/relationships/user(.:format)                                             lists/relationships/users#update
                                lists GET    /lists(.:format)                                                                         lists#index
                                      POST   /lists(.:format)                                                                         lists#create
                                 list GET    /lists/:id(.:format)                                                                     lists#show
                                      PATCH  /lists/:id(.:format)                                                                     lists#update
                                      PUT    /lists/:id(.:format)                                                                     lists#update
                                      DELETE /lists/:id(.:format)                                                                     lists#destroy
```

### Create controllers
Create a base controller that includes `Jaf::Base`. Now every
```ruby
class ApplicationController < ActiveRecord::API
  include Jaf::Base
end

class UsersController < ApplicationController
  include Jaf::Resources
end
```

- `Jaf::Base`: Include this in your ApplicationController, required for all the others.
- `Jaf::Resources`: Normal controller flow for `index`, `show`, `create`, `update` and `destroy`
- `Jaf::ToManyRelations`: Controller flow for `relationships/` endpoints. `create`, `update` and `destroy`
- `Jaf::ToOneRelations`: Controller flor for `relationships/` endpoints. `update`

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
