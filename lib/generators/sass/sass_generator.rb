require 'rails/generators'


class SassGenerator < Rails::Generators::NamedBase


  source_root File.expand_path('../templates', __FILE__)

  desc "This generator creates a coffee script file at app/assets/stylesheets/partials"

  argument :elements, type: :array, default: [], banner: "element element"


  attr_reader :namespace


  def copy_template_file
    @namespace = class_name.split("::")
    @namespace.pop
    @namespace = @namespace.join("::")
    template "sass.sass.erb", file_path
  end


  private



  def block_name
    file_name.underscore
  end



  def partial_file_name
    "_#{file_name}"
  end



  def file_path
    Rails.root.join("app/assets/stylesheets/partials", partial_file_name + ".sass")
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

end
