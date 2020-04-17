# frozen_string_literal: true

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
end
