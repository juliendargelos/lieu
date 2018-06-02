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
  PLURAL_PROPERTIES = [:eyes]

  belongs_to :user

  enum face: {
    circle: 0,
    oval: 1,
    rounded_square: 2,
    sharp: 3,
    square: 4,
    trapezium: 5
  }

  enum skin: {
    pale: 0,
    fair: 1,
    black: 3,
    dull: 4,
    red: 5,
    beige: 6
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

  enum mouth: {
    big_smile: 0,
    cat: 1,
    crescent: 2,
    double_lips: 3,
    long_lips: 4,
    long_semicircle: 5,
    neutral: 6,
    semicircle: 7,
    small_lips: 8,
    small_smile: 9
  }

  enum haircut: {
    ball: 0,
    big_bun: 1,
    big_buns: 2,
    bob: 3,
    braid: 4,
    braids: 5,
    cowlick: 6,
    curls: 7,
    long_curls: 8,
    long_straight: 9,
    long_straight_pushed_back: 10,
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

  enum sweater: {
    turquoise: 0,
    yellow: 1,
    pink: 2,
    purple: 3,
    green: 4,
    grey: 5
  }

  class << self
    def properties
      defined_enums.map{ |name, hash| [name.in?(PLURAL_PROPERTIES.map(&:to_s)) ? name : name.singularize, hash.values] }.to_h
    end
  end

  properties.each do |property, values|
    validates property, presence: true

    names = values.map{ |value| [value, send(property).to_s.gsub('_', '-')] }.to_h
    define_singleton_method("#{property}_names") { names }
    define_method("#{property}_name") { names[send(property)] }
  end
end
