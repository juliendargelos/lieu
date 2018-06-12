# == Schema Information
#
# Table name: chapters
#
#  id          :bigint(8)        not null, primary key
#  title       :string
#  content     :text
#  instruction :string
#  position    :integer
#  brush       :integer
#  book_id     :bigint(8)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Chapter < ActiveRecord::Base
  belongs_to :book
  has_many :readings, dependent: :destroy
  has_many :connections, through: :readings

  scope :with_instruction, -> { where.not instruction: nil }
  default_scope { order position: :asc }

  enum brush: {
    pen: 1,
    polygon: 2,
    circle: 3
  }

  def number
    position.to_s.rjust [2, book.chapters.pluck(:position).last.to_s.length].max, '0'
  end

  def brush_class
    brush.to_s.classify
  end

  def as_json(options = {})
    {
      id: id,
      title: title,
      content: content,
      instruction: instruction,
      brush: brush_class,
      position: position
    }.tap do |json|
      if options[:reading]
        reading = options[:reading]
        my_draw = reading.draw_for(self).as_json

        connected_draw = reading.connected? ? reading.connected_reading.draw_for(self).as_json : nil

        json.merge! draw: { mine: my_draw, connected: connected_draw }
      end
    end
  end
end
