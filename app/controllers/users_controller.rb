class UsersController < ApplicationController
  authenticates! :user, except: [:new, :create]
  unauthenticates! :user, only: [:new, :create]
  skip_before_action :redirect_to_explanations_path, only: :update
  skip_before_action :redirect_to_new_avatar_path, only: :update
  before_action :set_user, except: [:new, :create]

  def new
    @user = User.new
  end

  def edit

  end

  def create
    @user = User.new user_params

    if @user.save
      success "Bienvenue #{@user.pseudo} !"
      self.current_user = @user
      redirect_to explanations_path
    else
      render :new
    end
  end

  def update
    if @user.update user_params
      redirect_to new_avatar_path and return unless @user.has_avatar?
      success 'Les modifications ont bien été enregistrées'
      redirect_to dashboard_path
    else
      if @user.tutorial_done
        error "Impossible d'enregistrer les modifications"
        render :edit
      else
        error "Impossible de passer à la suite..."
        redirect_to explanations_path
      end
    end
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
