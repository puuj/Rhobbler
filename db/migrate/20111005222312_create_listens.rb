class CreateListens < ActiveRecord::Migration
  def change
    create_table :listens do |t|
      t.string :track_id, :null => false
      t.integer :user_id, :null => false
      t.date :date,       :null => false
      t.string :state,    :null => false

      t.timestamps
    end
  end
end
