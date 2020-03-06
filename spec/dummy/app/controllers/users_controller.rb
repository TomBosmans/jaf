# frozen_string_literal: true

class UsersController < ApplicationController
  include Jaf::Resources

  private

  def resource_params
    attributes.permit(:name, :email)
  end
end
