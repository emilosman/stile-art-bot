class Item < ApplicationRecord
  belongs_to :board

  has_one_attached :image, dependent: :purge
end
