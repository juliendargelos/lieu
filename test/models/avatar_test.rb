# == Schema Information
#
# Table name: avatars
#
#  id         :bigint(8)        not null, primary key
#  hair       :integer
#  eyes       :integer
#  face       :integer
#  clothes    :integer
#  mouth      :integer
#  skin       :integer
#  accessory  :integer
#  user_id    :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class AvatarTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
