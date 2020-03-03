# frozen_string_literal: true

module Jaf::Base
  def options
    @options ||= build_options
  end

  def build_options
    options = {}
    options[:include] = params[:include].split(',') if params[:include]
    options[:fields] = params[:fields].permit!.to_h.transform_values { |value| value.split(',') } if params[:fields]
    options
  end

  def data
    params.require(:data)
  end

  def attributes
    data.require(:attributes)
  end

  def serialize_object(data)
    serializer = "JsonApi::#{resource_model}Serializer".constantize
    serializer.new(data).serialized_json
  end

  def paginate(collection)
    page_size = params.dig(:page, :size)&.to_i
    page_number = params.dig(:page, :number)&.to_i
    return collection unless page_size && page_number

    Jaf::Pagination.filter(collection, size: page_size, number: page_number)
  end

  def sort(collection)
    sort = params[:sort]
    return collection unless sort

    sort_fields = Jaf::SortFields.deserialize(sort)
    collection.order(sort_fields)
  end

  def serialize(resource, options = {})
    serializer.new(resource, options).serializable_hash
  end

  def controller_name
    self.class.name
  end

  def modules
    controller_name.sub('JsonApi::', '').chomp('Controller').split('::')
  end

  def resource_name
    modules.last.singularize.downcase
  end

  def resource_model
    resource_name.camelcase.constantize
  end

  def resource_key
    many_relationship? ? resource_key.pluralize : resource_name
  end

  def many_relationship?
    parent.try(resource_name).blank?
  end

  def parent_name
    modules.first.singularize.downcase
  end

  def parent_model
    parent_name.camelcase.constantize
  end

  def parent_key
    "#{parent_name}_id"
  end

  def parent
    @parent ||= parent_model.find(parent_id)
  end

  def parent_id
    params[parent_key]
  end
end
