class DrawsController < ApplicationController
  authenticates! :user

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
end
