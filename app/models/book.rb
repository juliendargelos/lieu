# == Schema Information
#
# Table name: books
#
#  id                 :bigint(8)        not null, primary key
#  title              :string
#  number_of_chapters :integer
#  summary            :text
#  icon_file_name     :string
#  icon_content_type  :string
#  icon_file_size     :integer
#  icon_updated_at    :datetime
#  color              :integer
#  author             :string
#  status             :integer          default("draft")
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Book < ActiveRecord::Base
  has_many :chapters, dependent: :destroy
  has_many :readings, through: :chapters
  has_many :connections, -> (book) { unscope(:where).where('reading_id in (:ids) or other_reading_id in (:ids)', ids: book.readings.pluck(:id)).distinct }
  has_attached_file :icon

  validates :title, presence: true
  validates :number_of_chapters, presence: true, numericality: { integer: true, minimum: 0 }
  validates_attachment_content_type :icon, content_type: /\Aimage\/svg(?:\+xml)?\z/

  default_scope { order "status = #{statuses[:published]} desc, status = #{statuses[:draft]} desc" }

  enum color: {
    orange: 0,
    white: 1,
    blue: 2
  }

  enum status: {
    draft: 0,
    published: 1
  }

  def as_json(options = {})
    {
      icon: icon.url,
      color: color
    }
  end
end
