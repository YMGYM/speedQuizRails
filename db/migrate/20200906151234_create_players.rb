class CreatePlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :players do |t|
      t.references :room, null: false, foregin_key:true
      t.references :user, {null: false, foregin_key: true}

      t.boolean :isReady, default: false
      t.integer :score, default: 0
      t.integer :banPoint, default: 0
      t.boolean :isMaster, default: false

      t.timestamps
    end
  end
end