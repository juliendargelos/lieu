class AvatarsController < ApplicationController
  authenticates! :user
  skip_before_action :redirect_to_new_avatar_path, only: [:new, :create]
  before_action :redirect_to_books_path, if: :current_user_has_avatar?
  before_action :set_avatar, only: [:edit, :update]

  def new
    @avatar = Avatar.new
  end

  def edit

  end

  def create
    @avatar = Avatar.new avatar_params

    if @avatar.save
      success 'Tu as bien créé ton avatar !'
      redirect_to books_path
    else
      success "Ton avatar n'a pas pu êtr enregistré..."
      render :new
    end
  end

  def update
    if @avatar.update avatar_params
      success 'Tu as bien édité ton avatar !'
      redirect_to dashboard_path
    else
      render :edit
    end
  end

  private

  def set_avatar
    @avatar = current_user.avatar
  end

  def avatar_params
    params
      .require(:avatar)
      .permit(:haircut, :eyes, :face, :sweater, :mouth, :skin, :accessory)
      .tap { |p| p.merge! user_id: current_user.id }
  end
end
