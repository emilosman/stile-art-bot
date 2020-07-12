class Item < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :board

  has_one_attached :image, dependent: :destroy

  def image_url
    rails_blob_path(image, disposition: 'attachment') if image.present?
  end
end
