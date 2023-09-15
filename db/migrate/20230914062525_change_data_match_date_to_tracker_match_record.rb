class ChangeDataMatchDateToTrackerMatchRecord < ActiveRecord::Migration[7.0]
  def change
    change_column :tracker_match_records, :match_date, :date
  end
end
