class Book < ActiveRecord::Base
  has_attached_file :icon

  validates :title, presence: true
  validates :number_of_chapters, presence: true, numericality: { integer: true, minimum: 0 }
  validates_attachment_content_type :icon, content_type: /\Aimage\/svg(?:\+xml)?\z/
end
