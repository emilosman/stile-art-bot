class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items, id: :uuid do |t|
      t.string :text
      t.uuid :board_id, index: true

      t.timestamps
    end
  end
end
