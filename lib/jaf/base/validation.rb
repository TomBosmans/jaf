# frozen_string_literal: true

# All methods in this module are added to the Base module
# These are not supposed to be overridden but is always possible.
module Validation
  # Validates if the request contains the correct content type.
  def validate_content_type
    if request.headers['content-type'] != 'application/vnd.api+json'
      head :unsupported_media_type
    end
  end

  # Validate if the given query params are allowed.
  def validate_query_params
    errors = [].then(&method(:validate_query_param_keys_clause))
               .then(&method(:validate_include_clause))
               .then(&method(:validate_fields_clause))
               .then(&method(:validate_filters_clause))

    if errors.present?
      render json: serialize_errors(errors), status: :bad_request
    end
  end

  # Validate query params based on the #allowed_query_params
  def validate_query_param_keys_clause(errors)
    return errors unless query_params.keys

    query_params.keys.each_with_object(errors) do |key, errors|
      next errors if allowed_query_params.include?(key)

      errors.push(
        source: { parameter: key },
        title: 'Invalid Query Parameter',
        detail: "#{key} is unknown query parameter."
      )
    end
  end

  # Validate query params based on #allowed_includes
  def validate_include_clause(errors)
    return errors unless options[:include]

    options[:include].each_with_object(errors) do |included, errors|
      next errors if allowed_includes.include?(included)

      errors.push(
        source: { parameter: 'include' },
        title: 'Invalid Query Parameter',
        detail: "#{resource_name.capitalize} does not have an `#{included}` relationship path."
      )
    end
  end

  # Validate query params based on #allowed_fields.
  def validate_fields_clause(errors)
    return errors unless options[:fields]

    options[:fields].each_with_object(errors) do |(key, attributes), errors|
      attributes.each do |attribute|
        next errors if allowed_fields[key]&.include?(attribute)

        errors.push(
          source: { parameter: 'fields' },
          title: 'Invalid Query Parameter',
          detail: "#{key.capitalize} with attribute #{attribute}."
        )
      end
    end
  end

  # TODO: Validate query params based on #allowed_filters.
  def validate_filters_clause(errors)
    errors
  end
end
