class Board < ApplicationRecord
  belongs_to :user
  has_many :items, dependent: :destroy

  scope :with_items, -> { joins(:items).where.not(items: { id: nil }).uniq }

  before_create :set_share_id
  
  private
  def set_share_id
    self.share_id = SecureRandom.uuid
  end
end
