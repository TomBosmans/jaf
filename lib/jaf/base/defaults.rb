# frozen_string_literal: true

# All methods in this module are added to the Base module.
# These are intended to be overridden and offer a way to customize
# your controllers behaviour
module Defaults
  # Will be used to set the headers of the response.
  def set_response_content_type
    headers['Content-Type'] = 'application/vnd.api+json'
  end

  # List of allowed include query params
  # Example: ['todos', 'user']
  def allowed_includes
    []
  end

  # List of allowed field query params
  # Example: { 'todos' => ['created_at']. 'user' => ['name', 'email'] }
  def allowed_fields
    {}
  end

  # List of allowed filter query params
  def allowed_filters
    []
  end

  # List of allowed top level query params.
  def allowed_query_params
    %w[include fields filter sort page]
  end

  # Method hook called before serializing, can be used to authorize etc.
  def read_resource(resource)
    resource
  end

  # Method that will be triggered to create the new_resoruce. If this returns an active record with errors
  # the action will respond with unprocessable_entity.
  def create_resource(new_resource, attributes)
    new_resource.attributes = attributes
    new_resource.save
    new_resource
  end

  # Method that will trigger to update the resource. If this returns an active record with errors
  # the action will respond with unprocessable_entity.
  def update_resource(resource, attributes)
    resource.attributes = attributes
    resource.save
    resource
  end

  # Method that will trigger to destroy the resource.
  def destroy_resource(resource)
    resource.destroy
    resource
  end

  # The record found based on the resource_model and the params[:id]
  def resource
    resource_model.find(params[:id])
  end

  # Your starting collection.
  # This will be passed through multiple method hooks: filter -> sort -> paginate -> preload
  def base_collection
    @base_collection ||= resource_model.all
  end

  # Method hook that can be used to filter the given collection
  def filter(collection)
    collection
  end

  # Method hook that can be used to preload associations.
  def preload(collection)
    collection
  end

  # New instance of the model that will be used to create the new record.
  def new_resource
    base_collection.new
  end

  # Method hook that is used to paginate the given collection.
  # Used by the index
  def paginate(collection)
    page_size = params.dig(:page, :size)&.to_i
    page_number = params.dig(:page, :number)&.to_i
    return collection unless page_size && page_number

    Jaf::Pagination.filter(collection, size: page_size, number: page_number)
  end

  # Method that is used to sort the given collection.
  def sort(collection)
    sort = params[:sort]
    return collection unless sort

    sort_fields = Jaf::SortFields.deserialize(sort)
    collection.order(sort_fields)
  end

  # Whitelisted params that will be passed to the create_resource as attributes.
  # Recommended to use `deserialized_params` that converts the json:api formatted json into
  # Rails formatted json.
  def resource_params
    deserialized_params.permit!
  end

  # Used to serialize your data for the response.
  # Use a gem like fast_jsonapi to have the correct format for json:api spec.
  def serialize(resource, _options = {})
    resource.to_json
  end  
end
