class Jaf::InvalidArgumentErrorSerializer < Jaf::ErrorSerializer
  def initialize(errors)
    @errors = errors
  end

  def serialize
    { errors: errors_object }
  end

  private

  attr_reader :errors

  def errors_object
    errors.messages.inject([]) do |array, (attribute, messages)|
      messages.each do |message|
        source = { pointer: "data/attributes/#{attribute.to_s.camelize(:lower)}" }
        array.push({ source: source, detail: message })
      end

      array
    end
  end
end
