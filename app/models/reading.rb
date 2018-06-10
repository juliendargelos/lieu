# == Schema Information
#
# Table name: readings
#
#  id         :bigint(8)        not null, primary key
#  finished   :boolean          default(FALSE)
#  user_id    :bigint(8)
#  chapter_id :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Reading < ApplicationRecord
  belongs_to :user
  belongs_to :chapter
  has_many :draws
  has_one :book, through: :chapter
  has_one :connection, -> (reading) { unscope(:where).where 'reading_id = :id or other_reading_id = :id', id: reading.id }

  scope :current, -> { find_by finished: false }
  scope :for, -> (book) { find_by chapter_id: book.chapter_ids }

  def beggined?
    !chapter.position.zero?
  end

  def connect!
    (book.connections.pending.first || Connection.new).add(self).save
    self
  end

  def connected?
    connected_reading.present?
  end

  def connected_reading
    connection.other_reading_for self
  end

  def as_json(options = {})
    {
      id: id,
      chapter_id: chapter_id,
      user: {
        pseudo: user.pseudo,
        initial: user.initial,
        avatar: user.avatar.as_json
      },
    }.tap do |json|
      if options[:recursive] != false
        json.merge!(
          chapters: book.chapters.as_json(reading: self),
          connected_reading: connected_reading&.as_json(recursive: false)
        )
      end
    end
  end
end
