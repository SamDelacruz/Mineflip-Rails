# Top level game class, representing overall single game state
# Class is store for game objects
class Game
  private_class_method :new
  attr_reader :id, :board, :score, :game_over

  @games = []

  class << self
    attr_reader :games
    def start
      game_props = {
        id: next_id,
        board: Game::Board.random,
        score: 0,
        game_over: false
      }

      new game_props
    end

    def next_id
      @games.length
    end

    def find_by_id(id)
      @games[id] || raise("Game #{id} not found.")
    end

    def []=(id, game)
      @games[id] = game
    end
  end

  def initialize(id:, board:, score:, game_over:)
    @id        = id
    @board     = board
    @score     = score
    @game_over = game_over
  end

  def save
    Game[@id] = self
  end
end
