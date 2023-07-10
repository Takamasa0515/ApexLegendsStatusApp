class CreateGameAccountInfos < ActiveRecord::Migration[7.0]
  def change
    create_table :game_account_infos do |t|
      t.string :platform
      t.string :gameid
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
