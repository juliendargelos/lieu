class CreateAvatars < ActiveRecord::Migration[5.2]
  def change
    create_table :avatars do |t|
      t.integer :hair
      t.integer :eyes
      t.integer :face
      t.integer :clothes
      t.integer :mouth
      t.integer :skin
      t.integer :accessory
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
