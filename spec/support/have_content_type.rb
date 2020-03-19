RSpec::Matchers.define :have_content_type do |content_type|
  match do |response|
    content_type == content_type_header
  end

  failure_message do |response|
    "Content type #{content_type_header.inspect} should match #{content_type.inspect}"
  end

  failure_message_when_negated do |model|
    "Content type #{content_type_header.inspect} should not match #{content_type.inspect}"
  end

  def content_type_header
    response.headers['Content-Type']
  end
end
