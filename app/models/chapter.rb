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
  has_many :readings
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
end
