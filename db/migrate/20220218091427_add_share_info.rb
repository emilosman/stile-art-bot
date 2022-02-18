class AddShareInfo < ActiveRecord::Migration[6.0]
  def change
    add_column :items, :twitter_share_count, :integer, default: 0
    add_column :items, :telegram_share_count, :integer, default: 0
    add_index :items, :twitter_share_count
    add_index :items, :telegram_share_count

    add_column :items, :twitter_last_shared, :datetime
    add_column :items, :telegram_last_shared, :datetime
    add_index :items, :twitter_last_shared
    add_index :items, :telegram_last_shared
  end
end
