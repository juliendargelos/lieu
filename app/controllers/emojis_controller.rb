class EmojisController < ApplicationController
  authenticates! :user

  def create
    head Emoji.create(emoji_params) ? :ok : :unprocessable_entity
  end

  protected

  def emoji_params
    params.require(:emoji).permit :kind, :subject_id, :subject_type, :reading_id, position: [:x, :y]
  end
end
