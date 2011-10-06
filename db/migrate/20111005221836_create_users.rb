class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :lastfm_username,   :null => false
      t.string :session_key,       :null => false
      t.string :rhapsody_state,    :null => false
      t.string :lastfm_state,      :null => false
      t.string :rhapsody_username

      t.timestamps
    end
  end
end
