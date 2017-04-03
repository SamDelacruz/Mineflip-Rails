# Top level game class, representing overall single game state
# Class is store for game objects
class Game < ActiveRecord::Base
  serialize :board, Game::Board

  class << self
    def start
      game_props = {
        board: Game::Board.random,
        score: 0,
        game_over: false,
        game_won: false
      }

      build(game_props)
    end

    def build(props)
      game = Game.new
      game.board = props[:board]
      game.score = props[:score]
      game.game_over = props[:game_over]
      game.game_won = props[:game_won]
      game
    end
  end

  def game_over?
    game_over == true
  end

  def as_json(*)
    {
      id: id,
      score: score,
      game_over: game_over?,
      game_won: game_won?,
      board: board.tiles,
      hints: board.hints
    }
  end

  def reveal_tile(x, y)
    return unless board.hidden?(x, y)
    tile = board.reveal_tile(x, y)

    return if tile.nil?

    update_score(tile)
    board.reveal_all if tile.mine? && !game_over?
    self.game_over = tile.mine? || game_over
  end

  def update_score(tile)
    return score if game_over?
    self.score = score.zero? ? tile.value : tile.value * score
  end
end
