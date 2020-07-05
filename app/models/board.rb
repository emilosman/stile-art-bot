class Board < ApplicationRecord
  has_many :items, dependent: :destroy

  before_create :set_share_id

  private
  def set_share_id
    share_id = SecureRandom.uuid
  end
end
