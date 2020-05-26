# frozen_string_literal: true

require 'rails/generators'

class LayoutHelperGenerator < Rails::Generators::Base
  source_root File.expand_path('templates', __dir__)

  source_root File.expand_path('../templates', __FILE__)

  desc "This generator adds useful layout helper methods"


  def copy_template_file
    generate "helper", "Layout"
    add_title_method
    add_description_method
  end


  private

  def file_path
    Rails.root.join('app', 'helpers', "layout_helper.rb")
  end
  
  def add_title_method
    inject_into_file(file_path, after: "module LayoutHelper\n") do
      <<-RUBY
      
  def title(value = nil)
    if value
      @title = value
    else
      @title.to_s
    end
  end   
      RUBY
    end
  end
  
  def add_description_method
    inject_into_file(file_path, after: "module LayoutHelper\n") do
      <<-RUBY
      
  def description(value = nil)
    if value
      @description = value
    else
      @description.to_s
    end
  end
      RUBY
    end
  end
end
