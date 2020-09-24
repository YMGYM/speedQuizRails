class AddNickNameToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :nickName, :string
  end
end
