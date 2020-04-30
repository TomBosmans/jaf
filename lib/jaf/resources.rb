# frozen_string_literal: true

# The idea is that you should not override these action methods, but ofcourse that is always an option
# in situations that require it.
module Jaf::Resources
  # sends the base_collection through multiple methods you can hook into by
  # overriding them. filter -> sort -> paginate -> preload (see more in base/defaults.rb)
  # It adds to filtered base_collection count into the meta data that will be given to the serializer.
  def index
    options[:meta] = { total: filter(base_collection).count }
    collection = base_collection
                   .then(&method(:filter))
                   .then(&method(:sort))
                   .then(&method(:paginate))
                   .then(&method(:preload))

    render json: serialize(collection, options), status: :ok
  end

  # Sends the resource first into a read_resource method that can be hooked into by overriding it.
  # By default this hook method does nothing, but can be used for authorization etc.
  def show
    render json: serialize(read_resource(resource), options), status: :ok
  end

  # Sends the new_resource with the resource_params into the create_resource method.
  # When the returned object has errors or not will determine if the response will be a success or not.
  # There is basic logic for create_resource that works in simple situations, but you are supposed to
  # override this method. (see base/defaults.rb)
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

  # Sends the resource and the resource_params into the update_resource method.
  # When the returned object has errors or not will determine if the response will be a success or not.
  # There is basic logic for the update_resource that works in simple situations, but you are supposed to
  # override this method. (see base/defaults.rb)
  def update
    updated_resource = update_resource(resource, resource_params)
    if updated_resource.errors.blank?
      head :no_content
    else
      render json: serialize_invalid_attributes(updated_resource.errors),
             status: :unprocessable_entity
    end
  end

  # Sends the resource into the destroy_resource methodl.
  # TODO: handle failed destroy attempts.
  def destroy
    destroy_resource(resource)
    head :no_content
  end
end
