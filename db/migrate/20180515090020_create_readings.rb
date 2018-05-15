class CreateReadings < ActiveRecord::Migration[5.2]
  def change
    create_table :readings do |t|
      t.boolean :finished, default: false
      t.references :user, foreign_key: true
      t.references :chapter, foreign_key: true

      t.timestamps
    end
  end
end
