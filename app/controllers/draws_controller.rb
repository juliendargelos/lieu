class DrawsController < ApplicationController
  authenticates! :user
  before_action :set_draw, only: :show
  before_action :set_reading, :set_chapter, only: :create

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
    params.require(:draw).permit(:image).tap do |draw_params|
      draw_params.merge! reading: @reading, chapter: @chapter
    end
  end

  def set_reading
    @reading = current_user.readings.find params.require(:draw)[:reading_id]
  end

  def set_chapter
    @chapter = @reading.book.chapters.find params.require(:draw)[:chapter_id]
  end
end
