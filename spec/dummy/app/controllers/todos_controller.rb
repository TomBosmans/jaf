class TodosController < ApplicationsController
  include Jaf::Resources

  private

  def resource_params
    attributes.permit(:description)
  end
end
