# frozen_string_literal

class BaseControllerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)
  
  check_class_collision suffix: "Controller"

  desc "This generator creates a base controller for the named namespace"

  def ensure_file
    template "base_controller.rb.erb", 
             File.join("app", "controllers", plural_file_name, "base_controller.rb")
  end
  
  private
  
  
  def namespace_module
    file_name.to_s.split("/").first.classify.pluralize
  end
  
end
