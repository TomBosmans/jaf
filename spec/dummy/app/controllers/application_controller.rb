class ApplicationController < ActionController::API
  include Jaf::Base

  def serializer
    "#{resource_model}Serializer".constantize
  end

  def serialize(resource, options = {})
    serializer.new(resource, options).serialized_json
  end
end
