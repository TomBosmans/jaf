class ListsController < ApplicationController
  include Jaf::Resources

  private

  def resource_params
    attributes.permit(:name)
  end
end
