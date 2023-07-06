class Admin::XlquizzesController < ApplicationController

  def new
    @xlquiz = Xlquiz.new
  end

  def create
    @xlquiz = Xlquiz.new(xlquiz_params)
    respond_to do |format|
      if @xlquiz.save
        User.upload_users(@xlquiz)
        format.html {redirect_to users_path, notice: "File uploaded successfully"}
      else
        format.html render :new
      end
    end
  end

  def download_template
    send_file(
      "#{Rails.root}/public/UsersUpload.xlsx",
      filename: "UsersUpload.xlsx",
      type: "application/vnd.ms-excel"
    )
  end

  private
  def xlquiz_params
    params[:xlquiz].permit(:id, :book, :user_id)
  end


end
