# frozen_string_literal: true

def json_api_many(name, only: %w[index show create update destroy], except: [], set_relationship: true)
  resources name, only: only - except
  return unless set_relationship

  namespace :relationships do
    post name, to: "#{name}#create"
    put name, to: "#{name}#update"
    patch name, to: "#{name}#update"
    delete name, to: "#{name}#destroy"
  end
end

def json_api_one(name, only: %w[show update destroy], except: [], set_relationship: true)
  resource name, only: only - except
  return unless set_relationship

  namespace :relationships do
    resource name, only: %w[update]
  end
end

def json_api_resources(name, only: %w[index show create update destroy], except: [])
  resources name, only: only - except do
    scope module: name do
      yield if block_given?
    end
  end
end
