class Emoji < ApplicationRecord
  belongs_to :reading
  belongs_to :subject
end
