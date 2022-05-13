class CreateEmotions < ActiveRecord::Migration[6.1]
  def change
    create_table :emotions do |t|
      t.references :user
      t.references :video
      t.integer :emotion_type

      t.timestamps
    end
  end
end
