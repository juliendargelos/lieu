class UsersController < ApplicationController
  authenticates! :user, except: [:new, :create]
  unauthenticates! :user, only: [:new, :create]
  before_action :set_user, except: [:new, :create]

  def new
    @user = User.new
  end

  def edit

  end

  def create
    @user = User.new user_params

    if @user.save
      success "Bienvenue #{@user.pseudo}"
      self.current_user = @user
      redirect_to root_path
    else
      render :new
    end
  end

  def update
    if @user.update user_params
      success 'Les modifications ont bien été enregistrées'
    else
      error "Impossible d'enregistrer les modifications"
    end

    redirect_to edit_user_path(@user)
  end

  def destroy
    @user.destroy
    self.current_user = nil
    success 'Votre compte a bien été supprimé'
    redirect_to root_path
  end

  protected

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit :pseudo, :email, :password, :password_confirmation, :tutorial_done
  end
end
