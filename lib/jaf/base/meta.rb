# frozen_string_literal: true

# All methods in this module are added to the Base module.
# These are usually not needed to be overridden but is always possible.
# It uses the name of the controller to determine resource/parent/...
module Meta
  # Is used to determine what namespaces should be ignored to determine the resource and parent info.
  # This can be set on class levle by setting .ignore_namespaces=
  def ignore_namespaces
    self.class.ignore_namespaces
  end

  # Returns the name of the current controller
  def controller_name
    self.class.name
  end

  # Splitses the controller name into different modules.
  # Filters out based on #ignore_namespaces
  def modules
    name = ignore_namespaces.inject(controller_name) { |name, namespace| name.sub(namespace, '') }
    name.chomp('Controller').split('::').reject(&:empty?)
  end

  # The name of the current resource based on controller name.
  # Author::BooksController => 'book'
  def resource_name
    modules.last.singularize.underscore
  end

  # The model class of the current resource based on controller name.
  # Author::Bookscontroller => Book
  def resource_model
    resource_name.camelcase.constantize
  end

  # The name of the current resource parent based on controller name.
  # Author::BooksController => 'author'
  def parent_name
    modules.first.singularize.underscore
  end

  # The model of the current parent based on controller name.
  # Author::BooksController => Author
  def parent_model
    parent_name.camelcase.constantize
  end

  # The key of the parent for the current resource
  # Author::BooksController => author_id
  def parent_key
    "#{parent_name}_id"
  end

  # The parent of the current resource
  # Author::BooksController => author = Author.find(params[:id])
  def parent
    @parent ||= parent_model.find(parent_id)
  end

  # The id for the parent from the query params
  def parent_id
    params[parent_key]
  end
end
