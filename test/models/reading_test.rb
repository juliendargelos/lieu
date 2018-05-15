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

require 'test_helper'

class ReadingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
