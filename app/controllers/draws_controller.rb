class DrawsController < ApplicationController
  authenticates! :user
  before_action :respond_by_unprocessable_entity, unless: :current_user_reading?

  def create
    head Draw.create(draw_params) ? :ok : :unprocessable_entity
  end

  protected

  def draw_params
    params
      .require(:draw)
      .permit(:image)
      .tap { |p| p.merge! reading_id: current_user.reading.id, chapter_id: current_user.reading.chapter_id }
  end

  def respond_by_unprocessable_entity
    head :unprocessable_entity
  end
end
