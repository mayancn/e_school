class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  impersonates :user
  protect_from_forgery with: :exception

  helper_method :current_or_guest_user

  def current_or_guest_user
    if current_user
      if session[:guest_user_id] && session[:guest_user_id] != current_user.id
        logging_in
        # reload guest_user to prevent caching problems before destruction
        guest_user(with_retry = false).try(:reload).try(:destroy)
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end

  private

  def guest_user
    User.find(session[:guest_user_id].nil? ? session[:guest_user_id] = create_guest_user.id : session[:guest_user_id])
  end

  def create_guest_user
    u = User.create(:name => "guest",:role => "guest", :email => "guest_#{Time.now.to_i}#{rand(9)}@swalekhan.com")
    u.save(:validate => false)
    u
  end

  def after_sign_in_path_for(resource)
    if resource.role=="superadmin"
      users_path
    elsif resource.role == "admin" || resource.role == "teacher"
      admin_quizzes_path
    elsif resource.role == "student" || resource.role == "guest"
      quizzes_path
    else
      root_path
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :name, :last_name, :username, organization_attributes: [:id, :name]])
    devise_parameter_sanitizer.permit(:invite,  keys: [:organization_id, :name, :role])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :email, :password, :password_confirmation, :current_password])
    devise_parameter_sanitizer.permit(:accept_invitation, keys: [:organization_id, :username, :name, :email, :password, :password_confirmation, :invitation_token])
  end

end
