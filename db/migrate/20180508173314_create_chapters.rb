class CreateChapters < ActiveRecord::Migration[5.2]
  def change
    create_table :chapters do |t|
      t.string :title
      t.text :content
      t.string :instruction

      t.timestamps
  end
end
