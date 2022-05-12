class CreateVideos < ActiveRecord::Migration[6.1]
  def change
    create_table :videos do |t|
      t.references :user, null: false
      t.string :url, null: false
      t.string :embed_url, null: false
      t.string :title, null: false
      t.text :description

      t.timestamps
    end
  end
end
