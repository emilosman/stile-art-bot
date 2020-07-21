class Item < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :board

  has_one_attached :image, dependent: :destroy

  default_scope { order(position: :asc) }

  def image_url
    url_for(image) if image.present?
  end

  def thumbnail_url
    url_for(image.variant(resize: '500x')) if image.present?
  end
end
