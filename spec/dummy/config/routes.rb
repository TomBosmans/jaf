Rails.application.routes.draw do
  json_api_resources :users do
    json_api_many :lists
  end

  json_api_resources :lists do
    json_api_many :todos
    json_api_one :user

    get :permissions, to: 'permissions#index'
  end

  json_api_resources :todos do
    json_api_one :list
  end
end
