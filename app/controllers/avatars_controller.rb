class AvatarsController < ApplicationController
  authenticates! :user

  def index
  end

  def create
    @avatar = Avatar.new avatar_params.merge!(user: current_user)

    if @avatar.save
      redirect_to books_path
    else
      redirect_to explanations_path
    end

  end

  def show
  end

  private

  def avatar_params
    params.require(:avatar).permit :haircut, :eyes, :face, :sweater, :mouth, :skin, :accessory
  end


end
