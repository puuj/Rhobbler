class IndexesAndConstraints < ActiveRecord::Migration
  def up
    add_index :users, :rhapsody_username, :uniq => true
    add_index :users, :lastfm_username, :uniq => true

    add_index :listens, [:played_at, :user_id, :track_id], :uniq => true
    add_index :listens, :user_id
    add_index :listens, :track_id
    add_index :listens, :played_at
  end

  def down
    remove_index :users, :rhapsody_username
    remove_index :users, :lastfm_username

    remove_index :listens, [:played_at, :user_id, :track_id]
    remove_index :listens, :user_id
    remove_index :listens, :track_id
    remove_index :listens, :played_at
  end
end
