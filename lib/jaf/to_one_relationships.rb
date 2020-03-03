# frozen_string_literal: true

module Jaf::ToOneRelationships
  def update
    update_resource(parent, "#{resource_key}_id" => resource_id)
    head :no_content
  end

  private

  def resource_id
    data[:id]
  end
end
