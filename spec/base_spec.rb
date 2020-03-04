require 'rails_helper'

class BaseTest
  include Jaf::Base

  self.ignore_namespaces = %w[JsonApi V1]
end

module JsonApi
  module V1
    class Parent < BaseTest
      class Child < BaseTest
      end

      class OtherChild < BaseTest
        self.ignore_namespaces = %w[V1]
      end
    end
  end
end

RSpec.describe 'Base' do
  describe '.ignore_namespaces' do
    it 'filters out the given namespaces through inheritance' do
      expect(JsonApi::V1::Parent::Child.new.modules).to eq %w[Parent Child]
    end

    it 'can be overridden by a child' do
      expect(JsonApi::V1::Parent::OtherChild.new.modules).to eq %w[JsonApi Parent OtherChild]
    end
  end
end
