class AddUserIdToBoard < ActiveRecord::Migration[6.0]
  def change
    add_column :boards, :user_id, :uuid
    add_index :boards, :user_id
  end
end
