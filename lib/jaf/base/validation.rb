module Validation
  def validate_data_object_is_present
    return unless data

    error = {
      source: { pointer: '' },
      detail: "Missing `data` Member at document's top level."
    }

    render json: serialize_error(error), status: :unprocessable_entity
  end

  # Example: ['todos', 'user']
  def allowed_includes
    []
  end

  # Example: { 'todos' => ['created_at']. 'user' => ['name', 'email'] }
  def allowed_fields
    {}
  end

  def allowed_query_params
    %w[include fields filter sort page]
  end

  def validate_query_params(errors = [])
    errors = [].then(&method(:validate_query_param_keys_clause))
               .then(&method(:validate_include_clause))
               .then(&method(:validate_fields_clause))
               .then(&method(:validate_filters_clause))

    render json: serialize_errors(errors), status: :bad_request if errors.present?
  end

  def validate_query_param_keys_clause(errors)
    return errors unless query_params.keys

    query_params.keys.inject(errors) do |errors, key|
      next errors if allowed_query_params.include?(key)

      errors.push(
        source: { parameter: key },
        title: "Invalid Query Parameter",
        detail: "#{key} is unknown query parameter."
      )

      errors
    end
  end

  def validate_include_clause(errors)
    return errors unless options[:include]

    options[:include].inject(errors) do |errors, included|
      next errors if allowed_includes.include?(included)

      errors.push(
        source: { parameter: 'include' },
        title: "Invalid Query Parameter",
        detail: "#{resource_name.capitalize} does not have an `#{included}` relationship path."
      )

      errors
    end
  end

  def validate_fields_clause(errors)
    return errors unless options[:fields]

    options[:fields].inject(errors) do |errors, (key, attributes)|
      attributes.each do |attribute|
        next errors if allowed_fields[key]&.include?(attribute)

        errors.push(
          source: { parameter: 'fields' },
          title: "Invalid Query Parameter",
          detail: "#{key.capitalize} with attribute #{attribute}."
        )
      end

      errors
    end
  end

  def validate_filters_clause(errors)
    errors
  end
end
