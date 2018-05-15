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
  belongs_to :other_reading
end
