Rails.application.routes.draw do
  json_api_resources :users, lists: :to_many
  json_api_resources :lists, todos: :to_many, user: :to_one do
    get :permissions, to: 'permissions#index'
  end
  json_api_resources :todos, list: :to_one
end
