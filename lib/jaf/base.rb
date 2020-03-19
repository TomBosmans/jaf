# frozen_string_literal: true

require_relative 'base/validation'

module Jaf::Base
  extend ActiveSupport::Concern
  include Validation

  included do
    class_attribute :ignore_namespaces, default: []
    before_action :validate_content_type
    before_action :validate_query_params, on: :index

    rescue_from ActionController::ParameterMissing do |exception|
      pointer = %i[data attributes] # data/attributes
      index = pointer.index(exception.param) # where to cut off the pointer
      error = { source: { pointer: pointer.first(index).join('/') }, detail: exception.message }
      render json: serialize_error(error), status: :unprocessable_entity
    end

    rescue_from ActiveRecord::RecordNotFound do |exception|
      message = "Could not find #{exception.model} with id=#{exception.id}"
      render json: serialize_error(detail: message), status: :not_found
    end
  end

  def query_params
    request.query_parameters
  end

  def options
    @options ||= build_options
  end

  def serialize_invalid_attributes(errors)
    options = errors.messages.each_with_object([]) do |(attribute, messages), array|
      messages.each do |message|
        source = { pointer: "data/attributes/#{attribute.to_s.camelize(:lower)}" }
        array.push(source: source, detail: message)
      end
    end

    serialize_errors(options)
  end

  def serialize_error(error)
    serialize_errors([error])
  end

  def serialize_errors(errors)
    Jaf::ErrorSerializer.serialize(errors)
  end

  # options will be passed to your serializer.
  def build_options
    options = {}
    options[:include] = params[:include].split(',') if params[:include]
    if params[:fields]
      options[:fields] = params[:fields].permit!.to_h.transform_values { |value| value.split(',') }
    end
    options
  end

  # The data object from params
  def data
    params.require(:data)
  end

  # the attributes object from data object.
  def attributes
    data.require(:attributes)
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

  def ignore_namespaces
    self.class.ignore_namespaces
  end

  def modules
    name = ignore_namespaces.inject(controller_name) { |name, namespace| name.sub(namespace, '') }
    name.chomp('Controller').split('::').reject(&:empty?)
  end

  def resource_name
    modules.last.singularize.underscore
  end

  def resource_model
    resource_name.camelcase.constantize
  end

  def many_relationship?
    parent.try(resource_name).blank?
  end

  def parent_name
    modules.first.singularize.underscore
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
