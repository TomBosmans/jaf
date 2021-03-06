# frozen_string_literal: true

require 'fast_jsonapi'

class ApplicationSerializer
  include FastJsonapi::ObjectSerializer

  set_key_transform :camel_lower
end
