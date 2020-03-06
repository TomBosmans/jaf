require 'rails_helper'

RSpec.describe Jaf::ErrorSerializer do
  it 'can serialize multiple active record error messages' do
    errors = [
      { source: { pointer: 'data/attributes/name' }, detail: "can't be blank" },
      { source: { pointer: 'data/attributes/email' }, detail: "can't be blank" }
    ]

    expected = {
      errors: [
        { source: { pointer: 'data/attributes/name' }, detail: "can't be blank" },
        { source: { pointer: 'data/attributes/email' }, detail: "can't be blank" }
      ]
    }

    expect(described_class.serialize(errors)).to eq expected
  end
end
