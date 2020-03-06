# frozen_string_literal: true

class Lists::Relationships::TodosController < ApplicationController
  include Jaf::ToManyRelationships
end
