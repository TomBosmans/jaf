# frozen_string_literal: true

module Jaf
  class Pagination
    def initialize(collection, size:, number:)
      @collection = collection
      @size = size
      @number = number
    end

    def filter
      if collection.is_a? ActiveRecord::Relation
        collection.offset(offset).limit(size)
      else
        collection.drop(offset).first(size)
      end
    end

    def self.filter(*args)
      new(*args).filter
    end

    private

    attr_reader :collection, :size, :number

    def offset
      size * (number - 1)
    end
  end
end
