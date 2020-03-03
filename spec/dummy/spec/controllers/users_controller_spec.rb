require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe '#GET index' do
    it 'has a 200 status' do
      get :index
      expect(response).to have_http_status :ok
    end

    it 'paginates the resources' do
      create_list :user, 5
      get :index, params: { page: { number: 2, size: 2 } }
      expect(JSON.parse(response.body)['data'].count).to eq 2
    end

    it 'sorts the resources' do
      create_list :user, 5
      get :index, params: { sort: '-id' }
      ids = JSON.parse(response.body)['data'].map { |resource| resource['id'].to_i }
      expect(ids).to eq(User.order(id: :desc).ids)
    end
  end

  describe '#GET show' do
    it 'has a 200 status' do
      user = create :user
      get :show, params: { id: user.id }
      expect(response).to have_http_status :ok
    end
  end

  describe '#POST create' do
    it 'has a 201 status when creation succeeds' do
      attributes = attributes_for(:user, name: 'John Doe', email: 'john.doe@test.com')
      post :create, params: { data: { attributes: attributes } }
      expect(response).to have_http_status :created
    end

    it 'has a 422 status when there are errors' do
      attributes = attributes_for(:user, name: nil, email: 'john@doe.com')
      post :create, params: { data: { attributes: attributes } }
      expect(response).to have_http_status :unprocessable_entity
    end
  end

  describe '#PATCH update' do
    it 'has a 204 status when update succeeds' do
      user = create :user
      attributes = { name: 'new name' }
      patch :update, params: { id: user.id, data: { attributes: attributes } }
      expect(response).to have_http_status :no_content
    end

    it 'has a 422 status when there are errors' do
      user = create :user
      attributes = { name: nil }
      patch :update, params: { id: user.id, data: { attributes: attributes } }
      expect(response).to have_http_status :unprocessable_entity
    end
  end

  describe '#DELETE destroy' do
    it 'has a 204 status' do
      user = create :user
      delete :destroy, params: { id: user.id }
      expect(response).to have_http_status :no_content
    end
  end
end
