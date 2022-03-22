class TwitterBot < ApplicationRecord
  belongs_to :user
  has_many :items, through: :user

  def post_random_artwork
    if post_new_artwork.nil?
      selection =
        items.where('twitter_last_shared < (?)', (Time.now - 4.weeks)).random.presence ||
        items.where.not(id: items.last_shared.presence.try(:id)).random.presence ||
        items.random
      post_artwork(selection) if selection.present?
    end
  end
  
  def post_new_artwork
    selection = items.where(twitter_share_count: 0).random
    post_artwork(selection) if selection.present?
  end
  
  def post_artwork(selection)
    selection.increment!(:twitter_share_count)
    selection.update_attribute(:twitter_last_shared, Time.now)
    file = URI.open(selection.image_url)

    twitter_client.update_with_media("", file)
  end

  def test_tweet!
    twitter_client.update("test!")
  end

  def twitter_client
    Twitter::REST::Client.new do |config|
      config.consumer_key        =  Rails.application.credentials.fetch(:twitter_api)
      config.consumer_secret     =  Rails.application.credentials.fetch(:twitter_api_secret)
      config.access_token        = access_token
      config.access_token_secret = access_token_secret
    end
  end
end
