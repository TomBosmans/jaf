# frozen_string_literal: true

module Jaf
  class SortFields
    def initialize(string)
      @string = string
    end

    def deserialize
      array.inject({}) do |hash, field|
        hash.merge value_for(field)
      end
    end

    def self.deserialize(string)
      new(string).deserialize
    end

    private

    attr_reader :string

    def array
      string.split(',')
    end

    def value_for(field)
      if field[0] == '-'
        { field[1..-1].to_sym => :desc }
      else
        { field.to_sym => :asc }
      end
    end
  end
end
