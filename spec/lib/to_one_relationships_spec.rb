# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ToOneRelationships' do
  describe Lists::Relationships::UsersController, type: :controller do
    before { request.content_type = 'application/vnd.api+json' }

    describe 'PATCH #update' do
      it 'has a 204 status when succeeds' do
        list = create :list
        user = create :user
        patch :update, params: { list_id: list.id, data: { id: user.id } }
        expect(response).to have_http_status :no_content
      end

      it 'updates the relationships on the parent' do
        list = create :list
        user = create :user
        patch :update, params: { list_id: list.id, data: { id: user.id } }
        expect(list.reload.user).to eq user
      end

      it 'returns a 422 if it can not remove the relation' do
        user = create :user
        list = create :list, user: user
        patch :update, params: { list_id: list.id, data: { id: nil } }
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  describe Todos::Relationships::ListsController, type: :controller do
    before { request.content_type = 'application/vnd.api+json' }

    it 'removes relationships when data is empty' do
      list = create :list
      todo = create :todo, list: list
      patch :update, params: { todo_id: todo.id, data: { id: nil } }      
      expect(todo.reload.list).to be_nil
    end
  end
end
