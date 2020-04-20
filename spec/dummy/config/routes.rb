Rails.application.routes.draw do
  json_api_resources :users do
    json_api_many :lists, set_relationship: true
  end

  json_api_resources :lists do
    json_api_many :todos, set_relationship: true
    json_api_one :user, set_relationship: true

    get :permissions, to: 'permissions#index'
  end

  json_api_resources :todos do
    json_api_one :list, set_relationship: true
  end
end
