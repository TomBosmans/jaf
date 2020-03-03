class TodoSerializer < ApplicationSerializer
  set_type :todo
  set_id :id

  attributes :description
  belongs_to :list
end
