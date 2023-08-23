class AddDamagesToTrackerMatchRecords < ActiveRecord::Migration[7.0]
  def change
    add_column :tracker_match_records, :damages, :integer
  end
end
