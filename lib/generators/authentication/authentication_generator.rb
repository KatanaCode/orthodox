class AuthenticationGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)
  
  desc "Creates authentication views, controllers and models for a given Model"
  
  class_option :skip_views, type: :boolean, default: false

  class_option :skip_tests, type: :boolean, default: false
  
  class_option :two_factor, type: :boolean, default: false
  
  def create_controllers
    generate "base_controller", class_name
    template "controllers/sessions_controller.rb.erb", 
             "app/controllers/#{plural_file_name}/sessions_controller.rb"
    template "controllers/password_resets_controller.rb.erb", 
            "app/controllers/#{plural_file_name}/password_resets_controller.rb"

    if options[:two_factor]             
      template "controllers/tfa_sessions_controller.rb.erb", 
               "app/controllers/#{plural_file_name}/tfa_sessions_controller.rb"
              
      template "controllers/tfas_controller.rb.erb", 
               "app/controllers/#{plural_file_name}/tfas_controller.rb"
    end
  end

  def extend_controllers
    inject_into_class "app/controllers/#{plural_name}/base_controller.rb", 
                      "#{plural_class_name}::BaseController", 
                      "  authenticate_model :#{singular_name}, tfa: #{options[:two_factor]}\n"
    include_module_in_controller("#{plural_name}/base_controller", "Authentication")
    
  end
  
  def ensure_helpers
    if options[:two_factor]
      copy_file "helpers/otp_credentials_helper.rb", "app/helpers/otp_credentials_helper.rb"
    end
  end

  def ensure_js
    if options[:two_factor]
      copy_file "javascript/tfa_forms.js", "app/javascript/packs/tfa_forms.js"
    end
  end
  
  def create_mailer
    generate "mailer", "#{class_name}Mailer"
    inject_into_class "app/mailers/#{singular_name}_mailer.rb", "#{class_name}Mailer", <<~RUBY

    def password_reset_link(#{singular_name})
      @#{singular_name} = #{singular_name}
      mail(to: #{singular_name}.email, subject: "Reset your password")
    end
    
    RUBY
    template "views/mailers/password_reset_link.html.slim.erb",
             "app/views/#{singular_name}_mailer/password_reset_link.html.slim"
  end
      
  def create_models
    copy_file "models/password_reset_token.rb", "app/models/password_reset_token.rb"
    if options[:two_factor]
      template "models/otp_credential.rb.erb", "app/models/otp_credential.rb"
    end    
  end
  
  def extend_models
    include_module_in_model(class_name, "Authenticateable")
    include_module_in_model(class_name, "PasswordResetable")    
    if options[:two_factor]
      include_module_in_model(class_name, "Otpable")
    end
  end
  
  def create_form_objects
    template "models/session.rb.erb", "app/models/#{singular_name}_session.rb" 
    if options[:two_factor]
      copy_file "models/tfa_session.rb", "app/models/tfa_session.rb"
    end   
  end
  
  def ensure_concerns
    template "controllers/concerns/authentication.rb.erb", 
             "app/controllers/concerns/authentication.rb"
    copy_file "models/concerns/authenticateable.rb", 
              "app/models/concerns/authenticateable.rb"    
    copy_file "models/concerns/password_resetable.rb", 
              "app/models/concerns/password_resetable.rb"    

    if options[:two_factor]
      copy_file "controllers/concerns/two_factor_authentication.rb", 
                "app/controllers/concerns/two_factor_authentication.rb"    
      
      copy_file "models/concerns/otpable.rb", "app/models/concerns/otpable.rb"    
    end
  end

  def create_migrations
    generate "migration", "create_password_reset_tokens secret:token "\
                                                        "expires_at:datetime:index "\
                                                        "resetable:references{polymorphic}"
    if options[:two_factor]
      generate "migration", "create_otp_credentials \
                              created_at:datetime \
                              last_used_at:datetime \
                              secret:string{32} \
                              authable:references{polymorphic} \
                              recovery_codes:json"
    end    
  end
  
  def create_view_templates
    return if options[:skip_views]
    template "views/sessions/new.html.slim.erb", 
             "app/views/#{plural_name}/sessions/new.html.slim"    

    template "views/password_resets/new.html.slim.erb", 
             "app/views/#{plural_name}/password_resets/new.html.slim"    

    template "views/password_resets/edit.html.slim.erb", 
             "app/views/#{plural_name}/password_resets/edit.html.slim"    
             
    if options[:two_factor]
      template "views/tfa_sessions/new.html.slim.erb", 
               "app/views/#{plural_name}/tfa_sessions/new.html.slim"      
      template "views/tfas/show.html.slim.erb", 
               "app/views/#{plural_name}/tfas/show.html.slim"      
               
    end
  end
  
  def create_specs
    return if options[:skip_tests]
    
    copy_file "spec/support/factory_bot.rb", "spec/support/factory_bot.rb"
    
    template "spec/system/authentication_spec.rb.erb", 
             "spec/system/#{plural_name}/authentication_spec.rb" 

    template "spec/system/password_resets_spec.rb.erb", 
             "spec/system/#{plural_name}/password_resets_spec.rb" 
             
    template "spec/models/session_spec.rb.erb", 
            "spec/models/#{singular_name}_session_spec.rb" 
    
    copy_file "spec/models/password_reset_token_spec.rb", 
              "spec/models/password_reset_token_spec.rb"
    
    if options[:two_factor]
      copy_file "spec/support/authentication_helpers.rb", 
                "spec/support/authentication_helpers.rb"
      template "spec/models/tfa_session_spec.rb.erb", "spec/models/tfa_session_spec.rb"
      copy_file "spec/models/otp_credential_spec.rb", 
                "spec/models/otp_credential_spec.rb"      
      template "spec/system/tfa_authentication_spec.rb.erb", 
               "spec/system/#{plural_name}/tfa_authentication_spec.rb" 
      
    end
  end
  
  def create_factories
    generate "factory_bot:model", "otp_credential"
    generate "factory_bot:model", "password_reset_token"
    generate "factory_bot:model", "#{singular_name}_session email:email password:password"    
  end
  
  def ensure_gems
    gem "validates_email_format_of", version: "~> 1.6"
    gem "slim-rails"
    gem "factory_bot_rails"
    gem "faker"
    if options[:two_factor]
      gem "rotp", version: "~> 5.1.0"
      gem "rqrcode", require: false
    end
  end
  
  def create_routes
    route <<~RUBY
    namespace :#{plural_name} do
    
      resource :session, only: [:new, :create, :destroy]
    
      #{"resource :tfa_session, only: [:new, :create]" if options[:two_factor]}
    
      resource :tfa, only: [:create, :show, :destroy]
        
      resources :password_resets, only: [:new, :create, :edit, :update], param: :token
    
    end
    RUBY
  end
  
  private
  
  def plural_class_name
    class_name.pluralize
  end

  def include_module_in_controller(controller_name, module_name)
    class_name = controller_name.classify
    inject_into_class "app/controllers/#{controller_name}.rb", class_name, 
                      "  include #{module_name}\n"
    
  end
  
  def include_module_in_model(model_name, module_name)
    inject_into_class "app/models/#{model_name.underscore}.rb", model_name, 
                      "  include #{module_name}\n"
    
  end
end
