class Item < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :board

  has_one_attached :image, dependent: :destroy

  scope :by_position, -> { order(position: :asc) }
  scope :last_shared, -> { where.not(twitter_last_shared: nil).order(twitter_last_shared: :desc).first }
  scope :random,      -> { order('RANDOM()').first }

  def image_url
    if image.present?
      Rails.env.production? ? image.service_url : url_for(image) 
    end
  end

  def thumbnail_url
    url_for(image.variant(resize: '500x')) if image.present?
  end
end
