# frozen_string_literal: true

require_relative 'resources'

module Jaf::NestedResources
  include Jaf::Resources

  def base_collection
    parent.public_send(resource_name.pluralize)
  end

  def resource
    base_collection.find(params[:id])
  end
end
