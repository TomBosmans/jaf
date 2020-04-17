# frozen_string_literal: true

module Jaf::Resources
  def index
    filtered_collection = filter(base_collection)
    options[:meta] = { total: filtered_collection.count }
    collection = filtered_collection.then(&method(:sort)).then(&method(:paginate))
    render json: serialize(collection, options), status: :ok
  end

  def show
    render json: serialize(read_resource(resource), options), status: :ok
  end

  def create
    created_resource = create_resource(new_resource, resource_params)
    if created_resource.errors.blank?
      render json: serialize(created_resource),
             status: :created
    else
      render json: serialize_invalid_attributes(created_resource.errors),
             status: :unprocessable_entity
    end
  end

  def update
    updated_resource = update_resource(resource, resource_params)
    if updated_resource.errors.blank?
      head :no_content
    else
      render json: serialize_invalid_attributes(updated_resource.errors),
             status: :unprocessable_entity
    end
  end

  def destroy
    destroy_resource(resource)
    head :no_content
  end

  private

  def resource
    resource_model.find(params[:id])
  end

  def base_collection
    resource_model.all
  end

  # meant for filtering/scoping the base_collection
  def filter(collection)
    collection
  end

  def new_resource
    base_collection.new
  end
end
