class AddUserIdToTrackerMatchRecords < ActiveRecord::Migration[7.0]
  def change
    add_reference :tracker_match_records, :user, null: false, foreign_key: true
  end
end
