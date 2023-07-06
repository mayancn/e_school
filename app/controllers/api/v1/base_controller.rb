module Api
  module V1
    class BaseController < ActionController::API
      # include DeviseTokenAuth::Concerns::SetUserByToken
      # include RailsJwtAuth::AuthenticableHelper
      include ActionController::MimeResponds
      respond_to :json
      # before_action :authenticate!
      
      acts_as_token_authentication_handler_for User, fallback_to_devise: false

      before_action :configure_permitted_parameters, if: :devise_controller?
      before_action :destroy_session
      
      protected
      def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
      end
  
      def destroy_session
        request.session_options[:skip] = true
      end
    end
  end
end