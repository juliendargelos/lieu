# == Schema Information
#
# Table name: connections
#
#  id               :bigint(8)        not null, primary key
#  reading_id       :bigint(8)
#  other_reading_id :bigint(8)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Connection < ApplicationRecord
  belongs_to :reading
  belongs_to :other_reading, class_name: 'Reading', optional: true
  has_one :book, through: :reading

  scope :pending, -> { where other_reading: nil }

  def other_reading_for(reading)
    [reading, other_reading].find &reading.method(:!=)
  end

  def reading_for(user)
    user.readings.find_by id: [reading&.id, other_reading&.id].compact
  end

  def add(reading)
    assign_attributes "#{:other_ if reading_id.present?}reading": reading
    self
  end
end
