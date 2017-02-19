class Game
  private_class_method :new
  attr_reader :id, :board, :score, :game_over

  @@games = []

  class << self
    def start
      game_props = {
        id: next_id,
        board: Game::Board.random,
        score: 0,
        game_over: false,
      }

      new game_props
    end

    def next_id
      @@games.length
    end

    def find_by_id id
      game = @@games[id]
      if !game
        raise "Game #{id} not found."
      end
      game
    end
  end

  def initialize( id:, board:, score:, game_over: )
    @id        = id
    @board     = board
    @score     = score
    @game_over = game_over
  end

  def save
    @@games[@id] = self
  end


end
