class CreateDraws < ActiveRecord::Migration[5.2]
  def change
    create_table :draws do |t|
      t.attachment :image
      t.references :chapter, foreign_key: true
      t.references :reading, foreign_key: true

      t.timestamps
    end
  end
end
