# frozen_string_literal: true

require_relative 'base/validation'
require_relative 'base/meta'
require_relative 'base/defaults'

module Jaf::Base
  extend ActiveSupport::Concern
  include Validation
  include Meta
  include Defaults

  included do
    # Set these to ignore certain namespaces so Meta methods don't get confused.
    class_attribute :ignore_namespaces, default: []
    # Set the response content type before each action.
    before_action :set_response_content_type
    # Validate if the request has the correct content type.
    before_action :validate_content_type
    # Validate if the query params are allowed.
    before_action :validate_query_params, on: :index

    # Send response when parameter is missing.
    rescue_from ActionController::ParameterMissing do |exception|
      pointer = %i[data attributes] # data/attributes
      index = pointer.index(exception.param) # where to cut off the pointer
      error = { source: { pointer: pointer.first(index).join('/') }, detail: exception.message }
      render json: serialize_error(error), status: :unprocessable_entity
    end

    # Send response when Record could not be found.
    rescue_from ActiveRecord::RecordNotFound do |exception|
      message = "Could not find #{exception.model} with id=#{exception.id}"
      render json: serialize_error(detail: message), status: :not_found
    end
  end

  # Turns json:api formatted json payload into something rails would expect.
  def deserialized_params
    @deserialized_params ||= Jaf::Deserializer.new(params).deserialize
  end

  # Returns only the query params.
  def query_params
    request.query_parameters
  end

  # Returns the query params nested in the filter object
  def filter_params
    params[:filter]
  end

  # Returns the query params nested in the sort object
  def sort_params
    params[:sort]
  end

  # return the query params nested in the page object
  def page_params
    params[:page]
  end

  # return the query params nested in the include object
  # formatted to something more usable in rails.
  def include_params
    return unless params[:include]

    @include_params ||= params[:include].split(',')
  end

  # returns the query params nested in the field object
  # formatted to something more usable in rails.
  def field_params
    return unless params[:fields]
 
    @field_params ||= params[:fields].permit!.to_h.transform_values { |value| value.split(',') }
  end

  # Build error message for invalid attributes.
  def serialize_invalid_attributes(errors)
    options = errors.messages.each_with_object([]) do |(attribute, messages), array|
      messages.each do |message|
        source = { pointer: "data/attributes/#{attribute.to_s.camelize(:lower)}" }
        array.push(source: source, detail: message)
      end
    end

    serialize_errors(options)
  end

  # Build error message for a single error.
  def serialize_error(error)
    serialize_errors([error])
  end

  # Build error message for multiple errors.
  def serialize_errors(errors)
    Jaf::ErrorSerializer.serialize(errors)
  end

  # The options that will be given to the serialize method.
  # actions like index can add to these before they are being passed.
  def options
    return @options if @options

    @options = {}
    @options[:include] = include_params if include_params
    @options[:fields] = field_params if field_params
    @options
  end

  # The data object from params
  def data
    params.require(:data)
  end

  # the attributes object from data object.
  def attributes
    data.require(:attributes)
  end
end
