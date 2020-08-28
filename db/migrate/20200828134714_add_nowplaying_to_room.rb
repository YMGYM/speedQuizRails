class AddNowplayingToRoom < ActiveRecord::Migration[6.0]
  def change
    add_column :rooms, :nowPlaying, :boolean
  end
end
