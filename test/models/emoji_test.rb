# == Schema Information
#
# Table name: emojis
#
#  id           :bigint(8)        not null, primary key
#  kind         :integer
#  position     :jsonb
#  reading_id   :bigint(8)
#  subject_type :string
#  subject_id   :bigint(8)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class EmojiTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
