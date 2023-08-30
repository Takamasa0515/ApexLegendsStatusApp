class AddlastAccessedAtToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :last_accessed_at_overall, :datetime
  end
end
