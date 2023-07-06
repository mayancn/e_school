class UsersController < ApplicationController
   skip_before_action :authenticate_user!, only: [:registered]

  def index
    if current_user.role=="superadmin"
      @users = User.order_by(approved: "pending")
    else
      @users = current_user.organization.users.order_by(approved: "pending")
    end
  end

  def new
    @user = User.new
    @user.organization.build    
  end

  def create
    @user = User.new(params[:user])
    
    respond_to do |format|
      if @user.save
        UserMailer.with(user: @user).invite_email.deliver_now
      end
    end
  end

  def toggle_status
    if request.get?
      @user = User.find(params[:user_id])
    elsif request.patch?
      @user = User.find(params[:user_id])
      if @user.approved?
        @user.approved = false
      @user.save
      redirect_to users_path
      else
        @user.approved = true
        @user.save
              UserMailer.with(user: @user).approved_mail.deliver_now
              redirect_to users_path
      end
      end
  end

  def impersonate
    user = User.find(params[:id])
    impersonate_user(user)
    redirect_to root_path
  end

  def stop_impersonating
    stop_impersonating_user
    redirect_to root_path
  end

  def registered

  end

end
