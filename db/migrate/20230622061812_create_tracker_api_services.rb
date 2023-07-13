class CreateTrackerApiServices < ActiveRecord::Migration[7.0]
  def change
    create_table :tracker_api_services do |t|

      t.timestamps
    end
  end
end
