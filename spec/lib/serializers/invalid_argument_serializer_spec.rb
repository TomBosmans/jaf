require 'rails_helper'

RSpec.describe Jaf::InvalidArgumentErrorSerializer do
  it 'can serialize multiple active record error messages' do
    user = build :user, name: nil, email: nil
    user.valid?

    expected = {
      errors: [
        { source: { pointer: 'data/attributes/name' }, detail: "can't be blank" },
        { source: { pointer: 'data/attributes/email' }, detail: "can't be blank" }
      ]
    }

    expect(described_class.serialize(user.errors)).to eq expected
  end
end
