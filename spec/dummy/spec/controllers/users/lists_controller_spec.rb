require 'rails_helper'

RSpec.describe Users::ListsController, type: :controller do
  describe '#GET index' do
    it 'has a 200 status' do
      user = create :user
      get :index, params: { user_id: user.id }
      expect(response).to have_http_status :ok
    end

    it 'paginates the resources' do
      user = create :user
      create_list :list, 5, user: user
      get :index, params: { user_id: user.id, page: { number: 2, size: 2 } }
      expect(JSON.parse(response.body)['data'].count).to eq 2
    end

    it 'sorts the resources' do
      user = create :user
      create_list :list, 5, user: user
      get :index, params: { user_id: user.id, sort: '-id' }
      ids = JSON.parse(response.body)['data'].map { |resource| resource['id'].to_i }
      expect(ids).to eq(List.order(id: :desc).ids)
    end
  end

  describe '#GET show' do
    it 'has a 200 status' do
      user = create :user
      list = create :list, user: user
      get :show, params: { user_id: user.id, id: list.id }
      expect(response).to have_http_status :ok
    end
  end

  describe '#POST create' do
    it 'has a 201 status when creation succeeds' do
      user = create :user
      attributes = attributes_for :list
      post :create, params: { user_id: user.id, data: { attributes: attributes } }
      expect(response).to have_http_status :created
    end

    it 'has a 422 status when there are errors' do
      user = create :user
      attributes = attributes_for(:list, name: nil)
      post :create, params: { user_id: user.id, data: { attributes: attributes } }
      expect(response).to have_http_status :unprocessable_entity
    end
  end

  describe '#PATCH update' do
    it 'has a 204 status when update succeeds' do
      user = create :user
      list = create :list, user: user
      attributes = { name: 'new name' }
      patch :update, params: { user_id: user.id, id: list.id, data: { attributes: attributes } }
      expect(response).to have_http_status :no_content
    end

    it 'has a 422 status when there are errors' do
      user = create :user
      list = create :list, user: user
      attributes = { name: nil }
      patch :update, params: { user_id: user.id, id: list.id, data: { attributes: attributes } }
      expect(response).to have_http_status :unprocessable_entity
    end
  end

  describe '#DELETE destroy' do
    it 'has a 204 status' do
      user = create :user
      list = create :list, user: user
      delete :destroy, params: { user_id: user.id, id: list.id }
      expect(response).to have_http_status :no_content
    end
  end
end
