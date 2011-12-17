class ListensTimestamp < ActiveRecord::Migration
  def up
    change_table :listens do |t|
      t.remove   :date
      t.datetime :played_at
    end
  end

  def down
    change_table :listens do |t|
      t.date   :date
      t.remove :played_at
    end
  end
end
