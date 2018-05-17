# == Schema Information
#
# Table name: avatars
#
#  id         :bigint(8)        not null, primary key
#  haircut    :integer
#  eyes       :integer
#  face       :integer
#  sweater    :integer
#  mouth      :integer
#  skin       :integer
#  accessory  :integer
#  user_id    :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Avatar < ApplicationRecord
  belongs_to :user

  enum face: {
    circle: 0,
    oval: 1,
    rounded_square: 2,
    square: 3,
    trapezium: 4,
    triangle: 5
  }

  enum skin: { # TODO: write the corresponding BEM modifiers
    yellow: 0, # ffeedc
    fair: 1,   # f4d3d0
    black: 3,  # 77584d
    dull: 4,   # d3a98c
    red: 5,    # e0957c
    beige: 6   # f4c4a4
  }

  enum eyes: {
    almond_shapes: 0,
    circles_with_eyelashes: 1,
    falling_circles: 2,
    ovals: 3,
    semicircles: 4,
    slanting_shapes: 5,
    straight_circles: 6,
    surrounded_circles: 7
  }

  enum mouths: {
    big_smile: 0,
    cat: 1,
    crescent: 2,
    double_lips: 3,
    long_lips: 4,
    long_semicirle: 5,
    neutral: 6,
    semicirle: 7,
    small_lips: 8,
    small_smile: 9
  }

  enum haircut: {
    big_bun: 0,
    big_buns: 1,
    bob: 2,
    braid: 3,
    braids: 4,
    cowlick: 5,
    curls: 6,
    long_curls: 7,
    long_straight: 8,
    long_straight_pushed_back: 9,
    oval: 10,
    ponytail: 11,
    quiff: 12,
    rectangular: 13,
    round: 14,
    small_bun: 15,
    small_buns: 16,
    straight: 17,
    straight_pushed_back: 18,
    strand: 19,
    strands: 20,
    triangle: 21
  }

  enum accessory: {
    earings: 0,
    freckles: 1,
    hair_tie: 2,
    hairclip: 3,
    mole: 4,
    plaster: 5,
    rectangular_glasses: 6,
    round_glasses: 7
  }

  enum sweater: { # TODO: write the corresponding BEM modifiers
    turquoise: 0, # a6fff8
    yellow: 1,    # ffe36c
    pink: 2,      # ff6cbd
    purple: 3,    # b86eff
    green: 4,     # 8ee54a
    grey: 5       # dbdbdb
  }
end
