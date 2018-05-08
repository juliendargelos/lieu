class User < ApplicationRecord
  validates :pseudo, presence: { message: 'Il te faut un pseudo' }
  validates :pseudo, uniqueness: { message: 'Ce pseudo est déjà pris' }
  validates :pseudo, length: { minimum: 3, message: 'Ton pseudo doit contenir au moins 3 caractères' }, if: -> { pseudo.present? }
  validates :pseudo, format: { with: /\A[a-z0-9-_]+\z/i, message: 'Ton pseudo ne peut contenir que des chiffres, des lettres et les caractères "-" et "_"' }, if: -> { pseudo.present? }

  validates :email, presence: { message: 'Nous avons besoin de ton adresse mail' }
  validates :email, uniqueness: { message: 'Cette adresse mail est déjà utilisée' }, if: -> { email.present? }
  validates :email, email: { message: 'Cette adresse mail est invalide' }, if: -> { email.present? }

  validates :password, presence: { message: 'Il te faut un mot de passe' }
  validates :password, length: { minimum: 6, message: 'Ton mot de passe doit contenir au moins 6 caractères' }, if: -> { password.present? }
  validates :password, confirmation: { message: 'La confirmation ne correspond pas' }, if: -> { password.present? }

  has_secure_password validations: false

  def to_s
    pseudo
  end
end
