class List < ApplicationRecord
  belongs_to :user
  has_many :todos

  validates :name, presence: true
end
