class RemoveLastAccessedAtOverallFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :last_accessed_at_overall, :datetime
  end
end
