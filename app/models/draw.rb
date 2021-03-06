# == Schema Information
#
# Table name: draws
#
#  id                 :bigint(8)        not null, primary key
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#  chapter_id         :bigint(8)
#  reading_id         :bigint(8)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Draw < ApplicationRecord
  belongs_to :chapter
  belongs_to :reading
  has_many :emojis, as: :subject, dependent: :destroy

  validates :chapter, presence: true
  validates :reading, presence: true

  has_attached_file :image

  validates_attachment_content_type :image, content_type: 'image/png'
  validate do |draw|
    draw.errors.add :base, 'Invalid' unless draw.chapter.id.in? reading.book.chapter_ids
  end

  scope :for, -> (chapter) { find_by chapter: chapter }

  alias_method :base_image=, :image=
  def image=(v)
    if v.is_a?(String) && (result = /\Adata:image\/png;base64,(?<data>.+)/.match(v))
      v = StringIO.new Base64.decode64(result[:data]) if result
    end

    self.base_image = v
  end

  def as_json(options = {})
    {
      id: id,
      image: image.exists? ? image.url : nil,
      emojis: emojis.as_json
    }
  end

  protected

  def decode_base64_image
    if image_data && content_type && original_filename
      decoded_data = Base64.decode64(image_data)

      data = StringIO.new(decoded_data)
      data.class_eval do
        attr_accessor :content_type, :original_filename
      end

      data.content_type = content_type
      data.original_filename = File.basename(original_filename)

      self.image = data
    end
  end
end
