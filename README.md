## How to use

### Set up routes
We are going to use the [routes.rb](lib/jaf/routes.rb) helpers for this.

- `json_api_routes`: will create index/show/create/update/destroy endpoints
- `json_api_many`: will create index/show/create/update/destroy endpoints + create/update/destroy relations endpoints
- `json_api_one`: will create show/update/destroy endpoints + an update relations endpoint

They all accept `only` param to overwrite the endpoints it creates and an `set_relation`
that can be set to false if you don't want to create the relationship endpoints.
It is also possible to add extra endpoints inside the block.

```ruby
# config/routes.rb 
json_api_routes :lists do
  get :ability, to: 'ability#show'
  json_api_many :todos
  json_api_one :user
end
```

### Create the controllers
First we want to create an `ApplicationController` that will include [Base](lib/jaf/base.rb).
This will add some methods that help automate some of the process.
- `query_params`: returns only the query params
- `options`: options that can be given to the serializer (like meta info, current_user, ...)
- `serialize_error`: To serialize an error message (no external library needed)
- `serialize_errors`: To serialize multiple errors
- `data`: returns the data params.
- `attributes`: returns attributes params.
- `resource_name`: returns the name of the resource based on the controller name.
- `resource_model`: returns the resource model based on controller name.
- `parent_name`: returns the parent resource in a nested endpoint based on controller name.
- `parent_model`: returns the parent model in a nested endpoint based on controller name.
- `parent_id`: returns the parent id given through the params.

- `ignore_namespaces`: class attribute that can be set to ignore namespaces when determining `resource_model` etc.
    
```ruby
class ApplicationController < ActionController::API
  # self.ignore_namespaces = %w[json_api]
  include Jaf::Base
end
```

Now we can create our `ListsController` that includes [Resources](lib/jaf/resources.rb).
```ruby
class ListsController < ApplicationController
  include Jaf::Resources
  
  private

  def resource_params
    attributes.permit(:name, :description)
  end
end
```
The idea is that you overwrite the following methods to get the behaviour you want:

- `resource`: To fetch your record based on the params[:id].
- `resource_params`: Strong params given to update_resource and create_resource.
- `base_collection`: The record collection used as a base in the index
- `new_resource`: The initialized instance used to create a record.
- `create_resource`: move your create logic in here and make sure it returns the resource again, if it has no errors it is considered a success.
- `update_resource`: move your update logic in here and make sure it returns the updated record. If it has no errors it is considered a success.
- `destroy_resource`: move you destroy logic in here.
- `serialize`: Use a gem like fast_jsonapi or AMS to serialize your result.

Next you want to create your `Lists::TodosController` and `Lists::UsersController`
```ruby
# Assuming you already have a TodosController we can use that to inherit from
# This way we don't need to set resource_params a second time.
class Lists::TodosController < TodosController
  private

  def base_collection
    @base_collection ||= parent.todos
  end

  def resource
    @resource ||= base_collection.find(params[:id])
  end
end
```

Finally we can create our relationship controllers using [ToManyRelationships](lib/jaf/to_many_relationships.rb)
and [ToOneRelationships](lib/jaf/to_one_relationships.rb).
```ruby
class Lists::Relationships::ListsController < ApplicationController
  include Jaf::ToManyRelationships
end

class Lists::Relationships::UsersController < ApplicationController
  include Jaf::ToOneRelationships
end
```
