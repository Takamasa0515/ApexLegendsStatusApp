class RemoveProfileFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :profile, :string
  end
end
