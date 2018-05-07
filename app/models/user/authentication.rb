class User::Authentication < Authentication::Base
  has_model :user
  has_public :pseudo
  has_private :password

  validates :pseudo, presence: true
  validates :password, presence: true
end
