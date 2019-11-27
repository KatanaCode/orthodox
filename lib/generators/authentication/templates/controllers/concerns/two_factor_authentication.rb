module TwoFactorAuthentication
  extend ActiveSupport::Concern
  
  included do
  
  end
  
  module ClassMethods
    
    def define_tfa_methods(model_name)
      define_method :"authenticate_#{model_name}_with_tfa" do

        send(:"authenticate_#{model_name}_without_tfa")
        
        record = send(:"current_#{model_name}")
        return unless record
        if record.tfa? && !send(:"current_#{model_name}_tfa_authenticated?")
          redirect_to send(:"new_#{model_name.to_s.pluralize}_tfa_session_url"), 
                      warn: "You cannot proceed without authenticating"
        end                        
        
      end
      
      define_method :"current_#{model_name}_tfa_authenticated?" do
        session[:"#{model_name}_tfa_authenticated"] == true
      end
      
      define_method :"#{model_name}_tfa_success_redirect_url" do
        send(:"#{model_name.to_s.pluralize}_dashboard_url")
      end
      
      alias_method :"authenticate_#{model_name}_without_tfa", :"authenticate_#{model_name}"
                   
      alias_method :"authenticate_#{model_name}", :"authenticate_#{model_name}_with_tfa"
                   
    end
    
  end
  
end