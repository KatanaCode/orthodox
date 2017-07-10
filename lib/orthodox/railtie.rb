require 'orthodox'
require 'rails'

module Orthodox
  class Railtie < Rails::Railtie

    config.app_generators do |g|
      g.templates.unshift File::expand_path('../generators', __FILE__)
    end

  end
end
