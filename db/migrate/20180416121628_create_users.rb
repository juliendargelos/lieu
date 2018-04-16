class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :pseudo, index: true, unique: true, null: false
      t.string :email, unique: true
      t.string :password_digest

      t.timestamps
    end
  end
end
