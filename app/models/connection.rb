class Connection < ApplicationRecord
  belongs_to :reading
  belongs_to :other_reading
end
