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
end
