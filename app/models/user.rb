# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  pseudo          :string           not null
#  email           :string
#  password_digest :string
#  tutorial_done   :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  validates :pseudo, presence: { message: 'Il te faut un pseudo' }
  validates :pseudo, uniqueness: { message: 'Ce pseudo est déjà pris' }
  validates :pseudo, length: { minimum: 3, message: 'Ton pseudo doit contenir au moins 3 caractères' }, if: -> { pseudo.present? }
  validates :pseudo, format: { with: /\A[a-z0-9\-_]+\z/i, message: 'Ton pseudo ne peut contenir que des chiffres, des lettres et les caractères "-" et "_"' }, if: -> { pseudo.present? }

  validates :email, presence: { message: 'Nous avons besoin de ton adresse mail' }
  validates :email, uniqueness: { message: 'Cette adresse mail est déjà utilisée' }, if: -> { email.present? }
  validates :email, email: { message: 'Cette adresse mail est invalide' }, if: -> { email.present? }

  validates :password, presence: { message: 'Il te faut un mot de passe' }, allow_nil: true
  validates :password, length: { minimum: 6, message: 'Ton mot de passe doit contenir au moins 6 caractères' }, if: -> { password.present? }, allow_nil: true
  validates :password, confirmation: { message: 'La confirmation ne correspond pas' }, if: -> { password.present? }, allow_nil: true

  has_secure_password validations: false

  has_many :readings, dependent: :destroy
  has_many :draws, through: :readings
  has_one :avatar, dependent: :destroy

  scope :with_avatar, -> { joins :avatar }

  def to_s
    pseudo
  end

  def initial
    pseudo[0].upcase
  end

  def has_avatar?
    avatar.present?
  end

  def reading(options = {})
    options[:for] ? readings.find_by(chapter_id: options[:for].chapter_ids) : readings.find_by(finished: false)
  end

  def reading?(book = nil)
    reading(for: book).present?
  end

  def as_json(options = {})
    {
      pseudo: pseudo,
      initial: initial,
      avatar: avatar.as_json
    }
  end
end
