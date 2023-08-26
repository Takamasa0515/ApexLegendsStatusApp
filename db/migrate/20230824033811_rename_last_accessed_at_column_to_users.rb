class RenameLastAccessedAtColumnToUsers < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :last_accessed_at, :last_accessed_at_match_record
  end
end
