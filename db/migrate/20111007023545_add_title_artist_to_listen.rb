class AddTitleArtistToListen < ActiveRecord::Migration
  def change
    change_table :listens do |t|
      t.string :title, :null => false
      t.string :artist, :null => false
    end
  end
end
