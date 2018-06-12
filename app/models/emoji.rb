# == Schema Information
#
# Table name: emojis
#
#  id           :bigint(8)        not null, primary key
#  kind         :integer
#  position     :jsonb
#  reading_id   :bigint(8)
#  subject_type :string
#  subject_id   :bigint(8)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Emoji < ApplicationRecord
  belongs_to :reading
  belongs_to :subject, polymorphic: true

  validate do |emoji|
    valid = (
      (emoji.subject.is_a?(Draw) && emoji.reading&.id == emoji.subject.reading.connected_reading&.id) ||
      (emoji.subject.is_a?(Chapter) && emoji.reading&.book&.id == emoji.subject.book&.id)
    )

    emoji.errors.add :base, 'Invalid' unless valid
  end

  enum kind: {
    admire: 0,
    cute: 1,
    dubious: 2,
    lack_understanding: 3,
    laugh: 4,
    love: 5
  }

  def as_json(options = {})
    {
      kind: kind,
      position: position
    }
  end
end
