# frozen_string_literal: true

# The methods in this file are intended to help quickly add endpoints into your confit/routes.rb.
# without cluttering it.

# Add endpoints required for a to many relationship.
# You can exclude endpoints by adding them to except.
# By setting `set_relationships` to true it will also create the `/relationships` endpoints
# for post/patch/delete
def json_api_many(name, only: %w[index show create update destroy], except: [], set_relationship: false)
  resources name, only: only - except
  return unless set_relationship

  namespace :relationships do
    post name, to: "#{name}#create"
    put name, to: "#{name}#update"
    patch name, to: "#{name}#update"
    delete name, to: "#{name}#destroy"
  end
end

# Add endpoints required for a to one relationship
# You can exclude endpoints by adding them to except.
# By setting `set_relationships` to true it will also create the `/relationships` endpoint for patch
def json_api_one(name, only: %w[show update destroy], except: [], set_relationship: false)
  resource name, only: only - except
  return unless set_relationship

  namespace :relationships do
    resource name, only: %w[update]
  end
end

# Create top level endpoints.
def json_api_resources(name, only: %w[index show create update destroy], except: [])
  resources name, only: only - except do
    scope module: name do
      yield if block_given?
    end
  end
end
