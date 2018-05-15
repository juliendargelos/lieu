class CreateConnections < ActiveRecord::Migration[5.2]
  def change
    create_table :connections do |t|
      t.references :reading, foreign_key: true
      t.references :other_reading, foreign_key: { to_table: :readings }

      t.timestamps
    end
  end
end
