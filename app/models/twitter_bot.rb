class TwitterBot < ApplicationRecord
  belongs_to :user

  def post_random_artwork
    if post_new_artwork.nil?
      item =
        Item.published.where('twitter_last_shared < (?)', (Time.now - 4.weeks)).random.presence ||
        Item.published.random
      post_artwork(item) if item.present?
    end
  end
  
  def post_new_artwork
    item = Item.published.where(twitter_share_count: 0).random
    post_artwork(item) if item.present?
  end
  
  def post_artwork(item)
    item.increment!(:twitter_share_count)
    item.update_attribute(:twitter_last_shared, Time.now)
    file = URI.open(item.image.url)

    twitter_client.update_with_media(item.text, file)
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
