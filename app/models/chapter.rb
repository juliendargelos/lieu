# == Schema Information
#
# Table name: chapters
#
#  id          :bigint(8)        not null, primary key
#  title       :string
#  content     :text
#  instruction :string
#  position    :integer
#  book_id     :bigint(8)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Chapter < ActiveRecord::Base
  belongs_to :book
end
