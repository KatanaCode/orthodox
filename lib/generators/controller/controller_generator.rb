require 'rails/generators'


class ControllerGenerator < Rails::Generators::NamedBase

  check_class_collision suffix: "Controller"

  source_root File.expand_path('../templates', __FILE__)

  desc "This generator creates an initializer file at config/initializers"

  argument :actions, type: :array, default: [], banner: "action action"

  class_option :authenticate, type: :string, default: nil

  NON_TEMPLATE_ACTIONS = %w[create update destroy]

  attr_reader :namespace


  def copy_template_file
    @namespace = class_name.split("::")
    @namespace.pop
    @namespace = @namespace.join("::")
    template "controller.rb.erb", file_path
    (actions - NON_TEMPLATE_ACTIONS).each do |temp_name|
      template "view.html.slim", template_file_path(temp_name)
    end
  end


  private


  def create_flash_message
    "Successfully created #{singular_name}"
  end

  def update_flash_message
    "Successfully updated #{singular_name}"
  end

  def destroy_flash_message
    "Successfully destroyed #{singular_name}"
  end


  def file_path
    Rails.root.join('app', 'controllers', namespace_path + file_name + "_controller.rb")
  end

  def template_file_path(temp_name)
    Rails.root.join('app', 'views', namespace_path + file_name, temp_name + ".html.slim")
  end

  def namespace_path
    if namespace.blank?
      return ""
    else
      namespace.split("::").map(&:underscore).join("/") + "/"
    end
  end

  def singular_name
    super.singularize
  end

  def parent_class_name
    namespace.blank? ? 'ApplicationController' : namespace  + "::BaseControler"
  end

  def authenticate_actor?
    options['authenticate'].present?
  end

  def authenticate_actor
    options['authenticate']
  end

end
