class TodoSerializer < ApplicationSerializer
  set_type :todo
  set_id :id

  attributes :description, :created_at, :updated_at
  belongs_to :list
end
