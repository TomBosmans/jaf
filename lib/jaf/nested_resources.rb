# frozen_string_literal: true

require_relative 'resources'

module Jaf::NestedResources
  include Jaf::Resources

  def base_collection
    parent.public_send(resource_key)
  end
end
