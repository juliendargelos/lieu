class User::Authentication < Authentication::Base
  has_model :user
  has_public :pseudo
  has_private :password

  validates :pseudo, presence: { message: 'Nous avons besoin de ton pseudo' }
  validates :password, presence: { message: 'Nous avons besoin de ton mot de passe' }
end
