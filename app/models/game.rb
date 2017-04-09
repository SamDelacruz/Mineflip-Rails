# Top level game class, representing overall single game state
# Class is store for game objects
class Game < ActiveRecord::Base
  serialize :board, Game::BoardSerializer

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

  def lost?
    game_over == true
  end

  def won?
    game_won == true
  end

  def over?
    won? || lost?
  end

  def as_json(*)
    {
      id: id,
      score: score,
      game_over: lost?,
      game_won: won?,
      board: board.tiles,
      hints: board.hints
    }
  end

  def reveal_tile(x, y)
    return unless board.hidden?(x, y) || won?
    tile = board.reveal_tile(x, y)

    update_score(tile)

    check_win

    board.reveal_all if tile.mine? && !lost?
    self.game_over = tile.mine? || game_over
  end

  def check_win
    self.game_won = board.max_score == score
  end

  def update_score(tile)
    return score if won? || lost?
    self.score = score.zero? ? tile.value : tile.value * score
  end
end
