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
  PROPERTIES = {
    face: {
      name: 'Ton visage',
      title: 'Bien, à quoi ressemble la forme de ton visage ?',
      values: {
        circle: 0,
        oval: 1,
        rounded_square: 2,
        sharp: 3,
        square: 4,
        trapezium: 5
      }
    },

    skin: {
      name: 'Ta peau',
      title: 'Je vois ! Et maintenant ta couleur de peau.',
      values: {
        pale: 0,
        fair: 1,
        black: 3,
        dull: 4,
        red: 5,
        beige: 6
      }
    },

    eyes: {
      name: 'Tes yeux',
      title: 'Et maintenant tes yeux ?',
      values: {
        almond_shapes: 0,
        circles_with_eyelashes: 1,
        falling_circles: 2,
        ovals: 3,
        semicircles: 4,
        slanting_shapes: 5,
        straight_circles: 6,
        surrounded_circles: 7
      }
    },

    mouth: {
      name: 'Ta bouche',
      title: 'Pour sourire il te faut une bouche !',
      values: {
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
    },

    haircut: {
      name: 'Tes cheveux',
      title: 'Comment sont tes cheveux ?',
      values: {
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
    },

    accessory: {
      name: 'Ton accessoire',
      title: 'As-tu un accessoire ?',
      values: {
        nothing: 0,
        earings: 1,
        freckles: 2,
        hair_tie: 3,
        hairclip: 4,
        mole: 5,
        plaster: 6,
        rectangular_glasses: 7,
        round_glasses: 8
      }
    },

    sweater: {
      name: 'Ta couleur',
      title: 'Choisi une couleur !',
      values: {
        turquoise: 0,
        yellow: 1,
        pink: 2,
        purple: 3,
        green: 4,
        grey: 5
      }
    }
  }

  belongs_to :user

  class << self
    def properties
      @properties ||= PROPERTIES.map do |key, property|
        values = property[:values].map do |k, index|
          value = { index: index, modifier: k.to_s.split('_').join('-') }

          if key == :face
            value[:html] = ApplicationController.render partial: "avatars/faces/#{k}", locals: { edit: true }
          end

          [
            k,
            value
          ]
        end.to_h

        [
          key,
          property.merge(
            key: key,
            element: key.to_s.split('_').join('-'),
            values: values
          )
        ]
      end.to_h
    end
  end

  properties.each do |key, property|
    enum key => property[:values].transform_values { |value| value[:index] }
    define_method("#{key}_modifier") { property[:values][:"#{send(key)}"].try :[], :modifier }
    validates key, presence: true
  end

  def as_json(options = {})
    self.class.properties.map{ |k, _| [k, send(k)] }.to_h.merge! html: render
  end

  def render
    ApplicationController.render self
  end
end
