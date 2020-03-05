class Jaf::ErrorSerializer
  def self.serialize(*params)
    new(*params).serialize
  end

  def serialize
    { errors: nil }
  end
end
