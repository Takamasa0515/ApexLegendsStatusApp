class RemoveStartAtFromTrackerMatchRecord < ActiveRecord::Migration[7.0]
  def change
    remove_column :tracker_match_records, :start_time, :datetime
    remove_column :tracker_match_records, :end_time, :datetime
  end
end
