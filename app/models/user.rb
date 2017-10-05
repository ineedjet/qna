class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  def author_of?(object)
    self.id == object.user_id
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email] if auth.info?
    user = User.where(email: email).first
    if user
      user.authorizations.create(provider: auth.provider, uid: auth.uid)
    elsif email
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.authorizations.create(provider: auth.provider, uid: auth.uid)
    else
      user = User.new
    end
    user
  end

  def self.create_user_and_auth(email, provider, uid)
    password = Devise.friendly_token[0, 20]
    user = User.create!(email: email, password: password, password_confirmation: password)
    user.authorizations.create!(provider: provider, uid: uid)
    user
  end
end
