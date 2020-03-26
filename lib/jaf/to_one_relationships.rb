# frozen_string_literal: true

module Jaf::ToOneRelationships
  def update
    updated_parent = update_resource(parent, "#{resource_name}_id" => resource_id)
    if updated_parent.errors.blank?
      head :no_content
    else
      render json: serialize_invalid_attributes(updated_parent.errors),
             status: :unprocessable_entity
    end
  end

  private

  # replace -> data : { id: 1, type: 'list' }
  # remove  -> data : null
  def resource_id
    data&.fetch(:id)
  end
end
