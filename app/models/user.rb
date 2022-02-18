class User < ApplicationRecord
  has_one :board
  has_one :twitter_bot
  has_many :items, through: :board

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[twitter] # add these two! 

  after_save :check_bot

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      user.username = auth.info.nickname
      user.access_token = auth.credentials.token
      user.access_token_secret = auth.credentials.secret
      user.image = auth.info.image

      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  def email_required?
    false
  end

  private
  def check_bot
    TwitterBot.find_or_create_by(
      user_id: id,
      name: username,
      access_token: access_token,
      access_token_secret: access_token_secret
    )

    Board.find_or_create_by(
      user_id: id,
      title: username
    )
  end
end
