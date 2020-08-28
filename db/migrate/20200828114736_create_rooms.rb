class CreateRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :rooms do |t|
      t.string :title
      t.integer :question
      t.integer :questionNumber
      t.integer :limitTime
      t.boolean :isSecret
      t.string :password_digest

      t.timestamps
    end
  end
end
