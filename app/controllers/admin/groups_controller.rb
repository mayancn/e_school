class Admin::GroupsController < ApplicationController
  def index
    @groups = current_user.organization.groups
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    respond_to do |format|
      if @group.save
        format.html {redirect_to admin_groups_path, notice: "Group created successfully"}
      else
        format.html {render "new"}
      end
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    respond_to do |format|
      if @group.update(group_params)
        format.html {redirect_to admin_groups_path, notice: "Group Updated successfully"}
      end
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.delete
    redirect_to admin_groups_path
  end

  def add_users
    @group = Group.find(params[:group_id])
    @a_users = Array.new
    @users = nil
    if @group.group_type.downcase == "general"
      @users = User.where(organization_id: current_user.organization.id)
    elsif @group.group_type.downcase == "teachers"
      @users = User.where(organization_id: current_user.organization.id, role: "teacher")
    elsif @group.group_type.downcase == "students"
      @users = User.where(organization_id: current_user.organization.id, role: "student")
    end
    @users.each do |u|
      @a_users.push [u.id, u.name]
    end
  end

  private
  def group_params
    params[:group].permit(:id, :group_name, :group_type, :organization_id, user_ids: [])
  end

end


