class DrawsController < ApplicationController
  authenticates! :user
  before_action :set_draw, only: :show

  def show
    render json: { image: @draw.image.url }
  end

  def create
    head Draw.create(draw_params) ? :ok : :unprocessable_entity
  end

  protected

  def set_draw
    @draw = current_user.draws.find params[:id]
  end

  def draw_params
    params.require(:draw).permit(:image, :chapter_id).tap do |draw_params|
      draw_params.merge! reading: current_user.reading
    end
  end
end
