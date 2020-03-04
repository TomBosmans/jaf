require 'rails_helper'

RSpec.describe 'ToManyRelationships' do
  describe Users::Relationships::ListsController, type: :controller do
    describe 'POST #create' do
      it 'has a 204 status' do
        user = create :user
        lists = create_list :list, 3
        data = lists.map { |list| { id: list.id } }
        post :create, params: { user_id: user.id, data: data }
        expect(response).to have_http_status :no_content
      end

      it 'adds the given resources to the parent' do
        user = create :user
        linked_lists = create_list :list, 2, user: user
        new_lists = create_list :list, 3
        data = new_lists.map { |list| { id: list.id } }
        post :create, params: { user_id: user.id, data: data }
        user.reload

        expect(user.lists).to match_array(linked_lists + new_lists)
      end
    end

    describe 'PATCH #update' do
      it 'has a 204 status' do
        user = create :user
        lists = create_list :list, 3
        data = lists.map { |list| { id: list.id } }
        patch :update, params: { user_id: user.id, data: data }
        expect(response).to have_http_status :no_content
      end

      it 'replaces the parents resources' do
        user = create :user
        create_list :list, 2, user: user
        lists = create_list :list, 3
        data = lists.map { |list| { id: list.id } }
        patch :update, params: { user_id: user.id, data: data }
        expect(user.lists).to match_array(lists)
      end
    end

    describe 'DELETE #destroy' do
      it 'has a 204 status' do
        user = create :user
        lists = create_list :list, 3, user: user
        data = lists.map { |list| { id: list.id } }
        delete :destroy, params: { user_id: user.id, data: data }
        expect(response).to have_http_status :no_content
      end

      it 'removes the relationship with the parent' do
        user = create :user
        not_destroyed_lists = create_list :list, 3, user: user
        lists = create_list :list, 3, user: user
        data = lists.map { |list| { id: list.id } }
        delete :destroy, params: { user_id: user.id, data: data }
        expect(user.lists).to match_array(not_destroyed_lists)
      end

      it 'does not destroy the resources' do
        user = create :user
        lists = create_list :list, 3, user: user
        data = lists.map { |list| { id: list.id } }
        delete :destroy, params: { user_id: user.id, data: data }
        expect(lists.each(&:reload)).to be_present
      end
    end
  end
end
