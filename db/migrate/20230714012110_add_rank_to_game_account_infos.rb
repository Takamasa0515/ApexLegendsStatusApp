class AddRankToGameAccountInfos < ActiveRecord::Migration[7.0]
  def change
    add_column :game_account_infos, :rank, :string
  end
end
