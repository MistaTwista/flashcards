class UsersController < ApplicationController
  before_action :find_user, only: [:show, :update, :edit]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user
    else
      render "new"
    end
  end

  def update
    if @user.update(user_params)
      redirect_to @user
    else
      render "edit"
    end
  end

  def edit
  end

  def destroy
    User.delete(params[:id])
    redirect_to users_path
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
