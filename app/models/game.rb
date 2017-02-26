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

  def initialize(id:, board:, score: 0, game_over: false)
    @id        = id
    @board     = board
    @score     = score
    @game_over = game_over
  end

  def save
    Game[@id] = self
  end

  def game_over?
    @game_over == true
  end

  def as_json(*)
    {
      id: @id,
      score: @score,
      game_over: @game_over,
      board: show_board
    }
  end

  def show_board
    game_over? ? @board.tiles : @board.revealed
  end

  def reveal_tile(x, y)
    tile = @board.reveal_tile(x, y)
    @game_over = tile.bomb? unless tile.nil?
    update_score(tile) unless tile.nil?
  end

  def update_score(tile)
    @score = @score.zero? ? tile.value : tile.value * @score
  end
end
