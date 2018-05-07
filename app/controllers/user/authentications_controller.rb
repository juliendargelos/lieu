class User::AuthenticationsController < ApplicationController
  authenticates! :user, only: :destroy
  unauthenticates! :user, except: :destroy
  before_action :set_authentication, only: :destroy

  def new
    @authentication = User::Authentication.new
  end

  def create
    @authentication = User::Authentication.new user_authentication_params

    if @authentication.save
      success "Bienvenue #{@authentication.user}"
      redirect_to root_path
    else
      if @authentication.errors[:base].any?
        error @authentication.errors[:base].join("\n")
      end

      render :new
    end
  end

  def destroy
    @authentication.destroy
    info "À bientôt #{@authentication.user}"
    redirect_to root_path
  end

  protected

  def user_authentication_params
    params.require(:user_authentication).permit :pseudo, :password
  end

  def set_authentication
    @authentication = User::Authentication.current
  end
end
