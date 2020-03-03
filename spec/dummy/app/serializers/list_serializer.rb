class ListSerializer < ApplicationSerializer
  set_type :list
  set_id :id

  attributes :name
  belongs_to :user
  has_many :todos
end
