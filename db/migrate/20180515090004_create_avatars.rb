class CreateAvatars < ActiveRecord::Migration[5.2]
  def change
    create_table :avatars do |t|
      t.integer :haircut
      t.integer :eyes
      t.integer :face
      t.integer :sweater
      t.integer :mouth
      t.integer :skin
      t.integer :accessory, default: 0
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
