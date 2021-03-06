class UserSessionsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]

  def new
    @user = User.new
  end

  def create
    if @user = login(params[:email], params[:password])
      redirect_back_or_to(new_review_path, success: t("auth.login.ok"))
    else
      flash.now[:warning] = t("auth.login.failed")
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to(root_path, info: t("auth.login.out"))
  end
end
