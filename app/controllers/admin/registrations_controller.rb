class Admin::RegistrationsController < Devise::RegistrationsController

  def new
    build_resource({})
    self.resource.organization = Organization.new
    respond_with self.resource
  end

  protected
  def after_inactive_sign_up_path_for(resource)
    @users = User.where(role: "superadmin")
    @users.each do |u|
      UserMailer.with(user: u, org_user: resource, users_url: root_url.to_s + "admin/users").registered_mail.deliver_now
    end
    "/registered"
  end

end
