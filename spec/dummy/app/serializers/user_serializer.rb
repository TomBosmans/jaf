class UserSerializer < ApplicationSerializer
  set_type :user
  set_id :id

  attributes :name, :email, :created_at, :updated_at
  has_many :lists
end
