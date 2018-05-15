class CreateChapters < ActiveRecord::Migration[5.2]
  def change
    create_table :chapters do |t|
      t.string :title
      t.text :content
      t.string :instruction
      t.integer :position
      t.references :book, foreign_key: true

      t.timestamps
    end
  end
end
