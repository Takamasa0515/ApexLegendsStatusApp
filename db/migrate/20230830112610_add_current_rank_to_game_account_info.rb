class AddCurrentRankToGameAccountInfo < ActiveRecord::Migration[7.0]
  def change
    add_column :game_account_infos, :current_rank, :string
  end
end
