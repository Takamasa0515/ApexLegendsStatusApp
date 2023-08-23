class AddColumnToTrackerMatchRecords < ActiveRecord::Migration[7.0]
  def change
    add_column :tracker_match_records, :start_time, :datetime
    add_column :tracker_match_records, :end_time, :datetime
  end
end
