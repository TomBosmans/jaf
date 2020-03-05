class User < ApplicationRecord
  has_many :lists

  validates :name, presence: true
  validates :email, presence: true
end
