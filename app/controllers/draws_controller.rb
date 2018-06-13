class DrawsController < ApplicationController
  authenticates! :user
  before_action :respond_by_unprocessable_entity, unless: :current_user_reading?

  def create
    draw = Draw.new draw_params
    head draw.save ? :ok : :unprocessable_entity
  end

  protected

  def draw_params
    params
      .require(:draw)
      .permit(:image, :reading_id, :chapter_id)
  end

  def respond_by_unprocessable_entity
    head :unprocessable_entity
  end
end
