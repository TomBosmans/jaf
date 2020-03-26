# frozen_string_literal: true

class Todo < ApplicationRecord
  belongs_to :list, required: false
end
