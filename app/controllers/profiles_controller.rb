class ProfilesController < ApplicationController
  # отвечает за редактирование профиля
  before_action :set_profile, only: [:show, :edit, :update, :destroy]
  skip_before_action :require_login, only: [:new, :create]

  def index
    @profiles = User.all
  end

  def show
  end

  def edit
  end

  def update
    if @profile.update(user_params)
      redirect_to @profile, flash: { warning: 'User was successfully updated.' }
    else
      render :edit
    end
  end

  def destroy
    @profile.destroy
    redirect_to users_url, flash: { warning: 'User was successfully destroyed.' }
  end

  private
    def set_profile
      @profile = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
