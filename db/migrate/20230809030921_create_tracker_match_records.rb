class CreateTrackerMatchRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :tracker_match_records do |t|
      t.datetime :match_date
      t.string :legend
      t.integer :kills
      t.integer :wins

      t.timestamps
    end
  end
end
