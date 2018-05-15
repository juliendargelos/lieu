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
end
