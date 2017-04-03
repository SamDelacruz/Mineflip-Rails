class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.text :board
      t.integer :score
      t.boolean :game_over
      t.boolean :game_won
    end
  end
end
