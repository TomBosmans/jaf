require 'rails_helper'

RSpec.describe Jaf::Deserializer do
  it 'serializes into ActiveRecord::Base compliant format' do
    params = {
      data: {
        type: 'list',
        id: '1',
        attributes: {
          name: 'my name',
          description: 'something to describe'
        },
        relationships: {
          user: {
            data: { id: '1', type: 'user' }
          },
          todos: {
            data: [
              { type: 'todo', id: '1' },
              { type: 'todo', id: '2', attributes: { name: 'my todo' } }
            ]
          },
          activity: {
            data: { type: 'activity', attributes: { name: 'updated.list' } }
          },
          listSettings: {
            data: { type: 'listSetting', id: '1', attributes: { backgroundColor: 'red' } }
          }
        }
      }
    }

    params = ActionController::Parameters.new(JSON.parse(params.to_json))
    params = Jaf::Deserializer.new(params).deserialize
    expect(params.permit!.to_h).to(
      eq(
        'name' => 'my name',
        'description' => 'something to describe',
        'user_id' => '1',
        'todos_attributes' => [{ 'id' => '1' }, { 'id' => '2', 'name' => 'my todo' }],
        'activity_attributes' => { 'name' => 'updated.list' },
        'list_settings_attributes' => { 'background_color' => 'red', 'id' => '1' }
      )
    )
  end

  it 'works without relations being present' do
    params = {
      data: {
        type: 'list',
        id: '1',
        attributes: {
          name: 'hallo world',
          description: 'something to describe'
        }
      }
    }

    params = ActionController::Parameters.new(JSON.parse(params.to_json))
    params = Jaf::Deserializer.new(params).deserialize
    expect(params.permit!.to_h).to(
      eq(
        'name' => 'hallo world',
        'description' => 'something to describe'
      )
    )
  end

  it 'works without attributes being present' do
    params = {
      data: {
        type: 'list',
        id: '1',
        relationships: {
          todos: {
            data: [
              { id: '1', type: 'todo'  },
              { id: '2', type: 'todo' }
            ]
          }
        }
      }
    }

    params = ActionController::Parameters.new(JSON.parse(params.to_json))
    params = Jaf::Deserializer.new(params).deserialize
    expect(params.permit!.to_h).to(
      eq(
        'todos_attributes' => [
          { 'id' => '1' },
          { 'id' => '2' }
        ]
      )
    )
  end
end
