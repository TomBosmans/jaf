class ListSerializer < ApplicationSerializer
  set_type :list
  set_id :id

  attributes :name, :created_at, :updated_at
  belongs_to :user
  has_many :todos
end
