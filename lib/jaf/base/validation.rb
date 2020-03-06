# frozen_string_literal: true

module Validation
  # Example: ['todos', 'user']
  def allowed_includes
    []
  end

  # Example: { 'todos' => ['created_at']. 'user' => ['name', 'email'] }
  def allowed_fields
    {}
  end

  def allowed_filters
    []
  end

  def allowed_query_params
    %w[include fields filter sort page]
  end

  def validate_query_params
    errors = [].then(&method(:validate_query_param_keys_clause))
               .then(&method(:validate_include_clause))
               .then(&method(:validate_fields_clause))
               .then(&method(:validate_filters_clause))

    if errors.present?
      render json: serialize_errors(errors), status: :bad_request
    end
  end

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

  def validate_filters_clause(errors)
    errors
  end
end
