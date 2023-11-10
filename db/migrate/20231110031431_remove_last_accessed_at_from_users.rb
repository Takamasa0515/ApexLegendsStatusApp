class RemoveLastAccessedAtFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :last_accessed_at, :datetime
  end
end
