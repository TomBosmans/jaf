class Jaf::Deserializer
  attr_reader :document

  def initialize(document)
    @document = document.permit!.to_h.deep_transform_keys { |key| key.to_s.underscore.to_sym }
  end

  def deserialize
    ActionController::Parameters.new(attributes.merge(relationships))
  end

  def data
    document[:data]
  end

  def attributes
    data[:attributes]
  end

  def relationships
    data[:relationships]&.inject({}) do |hash, (key, value)|
      data = value[:data]

      if to_one_relation?(data) && !relation_with_attributes?(data)
        hash["#{key}_id".to_sym] = data[:id]
        next hash
      end

      attributes_key = "#{key}_attributes".to_sym

      if to_one_relation?(data) && relation_with_attributes?(data)
        hash[attributes_key] = deserialize_to_one_with_attributes(data)
        next hash
      end

      if to_many_relation?(data)
        hash[attributes_key] = deserialize_many_relation(data)
        next hash
      end
    end
  end

  def deserialize_to_one_with_attributes(data)
    hash = {}
    hash = hash.merge(data[:attributes]) if data[:attributes]&.present?
    hash = hash.merge(id: data[:id]) if data[:id]&.present?
    hash
  end

  def deserialize_many_relation(data)
    data.map do |record|
      hash = record[:attributes] || {}
      hash = hash.merge(id: record[:id]) if record[:id]&.present?
      hash
    end
  end

  def to_one_relation?(data)
    data.is_a? Hash
  end

  def to_many_relation?(data)
    data.is_a? Array
  end

  def relation_with_attributes?(data)
    to_one_relation?(data) ? data.include?(:attributes) : true
  end
end
