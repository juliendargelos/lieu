class EmojiController < ApplicationController
  authenticates! :user

  def create
    head Emoji.create(emoji_params) ? :ok : :unprocessable_entity
  end

  protected

  def emoji_params
    params
      .require(:emoji)
      .permit(:kind, :subject_id, :subject_type, :reading_id, position: [:x, :y])
      .tap { |p| p.merge! reading_id: (current_user.reading_ids & [p[:reading_id]]).first }
  end
end
