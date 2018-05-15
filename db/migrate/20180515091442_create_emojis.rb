class CreateEmojis < ActiveRecord::Migration[5.2]
  def change
    create_table :emojis do |t|
      t.integer :kind
      t.jsonb :position
      t.references :reading, foreign_key: true
      t.references :subject, polymorphic: true, index: true

      t.timestamps
    end
  end
end
