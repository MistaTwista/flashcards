class ProfilesController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def show
  end

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to profile_path, flash: { warning: t("user.updated") }
    else
      render :edit
    end
  end

  def destroy
    current_user.destroy
    redirect_to users_url, flash: { warning: t("user.destroyed") }
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation, :current_deck_id, :locale)
  end
end
