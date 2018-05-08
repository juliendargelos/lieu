class AddBookIdToChapters < ActiveRecord::Migration[5.2]
  def change
    add_reference :chapters, :book, index: true
    add_foreign_key :chapters, :books
  end
end
