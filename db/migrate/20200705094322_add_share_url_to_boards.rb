class AddShareUrlToBoards < ActiveRecord::Migration[6.0]
  def change
    add_column :boards, :share_id, :uuid, unique: true
    add_index :boards, :share_id
  end
end
