# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Validation' do
  describe ListsController, type: :controller do
    before { request.content_type = 'application/vnd.api+json' }

    it 'returns bad request' do
      get :index, params: { random: 'test' }
      expect(response).to have_http_status :bad_request
    end

    it 'does not allow unknown query params' do
      expected_body = {
        'errors' => [
          {
            'title' => 'Invalid Query Parameter',
            'detail' => 'byeWorld is unknown query parameter.',
            'source' => { 'parameter' => 'byeWorld' }
          },
          {
            'title' => 'Invalid Query Parameter',
            'detail' => 'halloWorld is unknown query parameter.',
            'source' => { 'parameter' => 'halloWorld' }
          }
        ]
      }

      get :index, params: { 'halloWorld' => 'hallo', 'byeWorld' => 'bye' }
      expect(JSON.parse(response.body)).to eq expected_body
    end

    it 'does not allow includes that do not exist' do
      expected_body = {
        'errors' => [
          {
            'title' => 'Invalid Query Parameter',
            'detail' => 'List does not have an `users` relationship path.',
            'source' => { 'parameter' => 'include' }
          },
          { 'title' => 'Invalid Query Parameter',
            'detail' => 'List does not have an `random` relationship path.',
            'source' => { 'parameter' => 'include' } }
        ]
      }

      get :index, params: { include: 'users,random' }
      expect(JSON.parse(response.body)).to eq expected_body
    end

    it 'does not allow fields from not included or not existing relations' do
      expected_body = {
        'errors' => [
          {
            'title' => 'Invalid Query Parameter',
            'detail' => 'List with attribute hallo.',
            'source' => { 'parameter' => 'fields' }
          },
          {
            'title' => 'Invalid Query Parameter',
            'detail' => 'Other with attribute test.',
            'source' => { 'parameter' => 'fields' }
          },
          {
            'title' => 'Invalid Query Parameter',
            'detail' => 'Todos with attribute description.',
            'source' => { 'parameter' => 'fields' }
          }
        ]
      }

      get :index, params: { include: 'user', fields: { user: 'name', todos: 'description', other: 'test', list: 'hallo' } }
      expect(JSON.parse(response.body)).to eq expected_body
    end

    it 'can return different query param errors' do
      expected_body = {
        'errors' => [
          {
            'title' => 'Invalid Query Parameter',
            'detail' => 'hallo is unknown query parameter.',
            'source' => { 'parameter' => 'hallo' }
          },
          {
            'title' => 'Invalid Query Parameter',
            'detail' => 'List does not have an `random` relationship path.',
            'source' => { 'parameter' => 'include' }
          },
          {
            'title' => 'Invalid Query Parameter',
            'detail' => 'User with attribute random.',
            'source' => { 'parameter' => 'fields' }
          }
        ]
      }

      get :index, params: { include: 'random', fields: { user: 'random' }, hallo: 'world' }
      expect(JSON.parse(response.body)).to eq expected_body
    end

    it 'does not allow random Content-Type in the header' do
      request.content_type = 'application/json'
      get :index
      expect(response).to have_http_status :unsupported_media_type
    end
  end
end
