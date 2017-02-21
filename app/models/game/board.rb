class Game
  # Class representing the gameboard
  # 2D grid of tiles which may be a bomb, number, or unknown
  class Board
    private_class_method :new
    attr_reader :tiles, :revealed

    WIDTH = HEIGHT = SIZE = 5

    WEIGHTS = {
      bomb: 3,
      one:  4,
      two:  2,
      three: 1
    }.freeze

    class << self
      def random
        tiles = Array.new(HEIGHT) do
          Array.new(WIDTH) { Game::Tile.random(WEIGHTS) }
        end

        revealed = Array.new(HEIGHT) do
          Array.new(WIDTH) { Game::Tile.new(type: :hidden) }
        end

        new tiles: tiles, revealed: revealed
      end
    end

    def initialize(tiles:, revealed:)
      @tiles    = tiles
      @revealed = revealed
    end

    def to_s
      tiles = @tiles.map { |r| r.join(',') }.join("\n")
      revealed = @revealed.map { |r| r.join(',') }.join("\n")
      "#{tiles}\n\n#{revealed}"
    end
  end
end
