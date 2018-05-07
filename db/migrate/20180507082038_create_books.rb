class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :title
      t.integer :number_of_chapters
      t.text :summary
      t.attachment :icon
      t.string :author

      t.timestamps
    end
  end
end
