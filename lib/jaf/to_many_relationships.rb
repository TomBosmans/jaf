# frozen_string_literal: true

module Jaf::ToManyRelationships
  def create
    resource_model.where(id: resource_ids).each do |resource|
      update_resource(resource, parent_key => parent.id)
    end

    head :no_content
  end

  def update
    resources = resource_model.where(id: resource_ids)
    update_resource(parent, resource_name.pluralize => resources)
    head :no_content
  end

  def destroy
    parent.send(resource_name.pluralize).where(id: resource_ids).each do |resource|
      update_resource(resource, parent_key => nil)
    end

    head :no_content
  end

  private

  def resource_ids
    data.map { |resource| resource[:id] }
  end
end
