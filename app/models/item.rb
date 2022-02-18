class Item < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :board

  has_one_attached :image, dependent: :destroy

  default_scope { order(position: :asc) }
  scope :random, -> { order('RANDOM()').first }

  def image_url
    if image.present?
      Rails.env.production? ? image.service_url : url_for(image) 
    end
  end

  def thumbnail_url
    url_for(image.variant(resize: '500x')) if image.present?
  end
end
