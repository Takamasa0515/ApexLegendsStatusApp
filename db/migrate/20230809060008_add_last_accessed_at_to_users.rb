class AddLastAccessedAtToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :last_accessed_at, :datetime
  end
end
