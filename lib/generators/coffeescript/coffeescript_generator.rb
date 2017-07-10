require 'rails/generators'


class CoffeescriptGenerator < Rails::Generators::NamedBase


  source_root File.expand_path('../templates', __FILE__)

  desc "This generator creates a coffee script file at app/assets/javascripts/partials"

  argument :functions, type: :array, default: [], banner: "functionOne functionTwo"


  attr_reader :namespace


  def copy_template_file
    @namespace = class_name.split("::")
    @namespace.pop
    @namespace = @namespace.join("::")
    template "coffeescript.coffee.erb", file_path
  end


  private



  def function_name
    file_name.camelize(:lower)
  end



  def partial_file_name
    "_#{file_name}"
  end



  def file_path
    Rails.root.join("app/assets/javascripts/partials", partial_file_name + ".coffee")
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



  # def authenticate_actor?
  #   options['authenticate'].present?
  # end



  # def authenticate_actor
  #   options['authenticate']
  # end

end