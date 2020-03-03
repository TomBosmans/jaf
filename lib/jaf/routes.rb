# frozen_string_literal: true

def json_api_resources(name, relations = {})
  resources name, only: %w[index show create update destroy] do
    scope module: name do
      yield if block_given?
      relations.map do |relation_name, type|
        case type
        when :to_one
          resource relation_name, only: %w[show update destroy]
        when :to_many
          resources relation_name, only: %w[index show create update destroy]
        end
      end
      namespace :relationships do
        relations.map do |relation_name, type|
          case type
          when :to_one
            resource relation_name, only: %w[update]
          when :to_many
            post relation_name, to: "#{relation_name}#create"
            put relation_name, to: "#{relation_name}#update"
            patch relation_name, to: "#{relation_name}#update"
            delete relation_name, to: "#{relation_name}#destroy"
          end
        end
      end
    end
  end
end
