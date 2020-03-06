# frozen_string_literal: true

class ListsController < ApplicationController
  include Jaf::Resources

  private

  def resource_params
    attributes.permit(:name)
  end
end
