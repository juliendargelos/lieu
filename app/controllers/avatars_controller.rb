class AvatarsController < ApplicationController
  authenticates! :user
  before_action :redirect_to_books, if: :current_user_has_avatar?

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

  private

  def avatar_params
    params.require(:avatar).permit :haircut, :eyes, :face, :sweater, :mouth, :skin, :accessory
  end

  def redirect_to_books
    redirect_to books_path
  end

  def current_user_has_avatar?
    current_user.avatar&.persisted?
  end
end
