class ProfilesController < ApplicationController
  # отвечает за редактирование профиля
  skip_before_action :require_login, only: [:new, :create]

  def show
  end

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to edit_profile_path, flash: { warning: 'User was successfully updated.' }
    else
      render :edit
    end
  end

  def destroy
    current_user.destroy
    redirect_to users_url, flash: { warning: 'User was successfully destroyed.' }
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
