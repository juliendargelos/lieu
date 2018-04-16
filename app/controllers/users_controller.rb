class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new user_params
    if @user.save
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def update
    @user.update user_params
    render :edit
  end

  def destroy
    @user.destroy
    redirect_to root_path
  end

  protected

  def set_user
    @user = User.find params[:id]
  end

  def user_params
    params.require(:user).permit(:pseudo, :email, :password, :password_confirmation)
  end

end
