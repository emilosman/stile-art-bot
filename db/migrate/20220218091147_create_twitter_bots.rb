class CreateTwitterBots < ActiveRecord::Migration[6.0]
  def change
    create_table :twitter_bots, id: :uuid do |t|
      t.string :consumer_key
      t.string :consumer_secret
      t.string :access_token
      t.string :access_token_secret
      t.string :name, null: false
      t.uuid   :user_id, null: false

      t.index :name
      t.index :user_id
      t.timestamps
    end
  end
end
