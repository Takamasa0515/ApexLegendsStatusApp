class RemoveRankFromGameAccountInfo < ActiveRecord::Migration[7.0]
  def change
    remove_column :game_account_infos, :rank, :string
  end
end
