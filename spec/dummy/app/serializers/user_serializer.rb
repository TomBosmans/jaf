class UserSerializer < ApplicationSerializer
  set_type :user
  set_id :id

  attributes :name, :email
  has_many :lists
end
