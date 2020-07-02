class Board < ApplicationRecord
  has_many :items, dependent: :destroy
end
