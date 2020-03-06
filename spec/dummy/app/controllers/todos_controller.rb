# frozen_string_literal: true

class TodosController < ApplicationController
  include Jaf::Resources

  private

  def resource_params
    attributes.permit(:description)
  end
end
