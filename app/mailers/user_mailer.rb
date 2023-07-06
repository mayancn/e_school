class UserMailer < ApplicationMailer

  def invite_mail
    mail to: @user.email, from: ENV['EMAIL'], subject: "You are invited to join ESchool Bag"
  end

  def registered_mail
    @user = params[:user]
    @org_user = params[:org_user]
    @users_url = params[:users_url]
    mail(to: @user.email, from: ENV['EMAIL'], subject: "Approve the organization")
  end

  def approved_mail
    @user = params[:user]
    mail(to: @user.email, from: ENV['EMAIL'], subject: "Your organization has been approved")
  end


end
