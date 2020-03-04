require 'rails_helper'

RSpec.describe 'ToOneRelationships' do
  describe Lists::Relationships::UsersController, type: :controller do
    describe 'PATCH #update' do
      it 'has a 204 status' do
        list = create :list
        user = create :user
        patch :update, params: { list_id: list.id, data: { id: user.id }}
        expect(response).to have_http_status :no_content
      end

      it 'updates the relationships on the parent' do
        list = create :list
        user = create :user
        patch :update, params: { list_id: list.id, data: { id: user.id }}
        expect(list.reload.user).to eq user
      end
    end
  end
end
