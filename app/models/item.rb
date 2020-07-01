class Item < ApplicationRecord
  validates :image, presence: true

  belongs_to :board

  has_one_attached :image
end
