# frozen_string_literal: true

class Users::Relationships::ListsController < ApplicationController
  include Jaf::ToManyRelationships
end
