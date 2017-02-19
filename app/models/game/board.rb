class Game::Board
  private_class_method :new

  WIDTH = HEIGHT = SIZE = 5

  class << self
    def random
      weights = {
        bomb: 3,
        one:  4,
        two:  2,
        three: 1
      }

      tiles = Array.new(HEIGHT) do
        Array.new(WIDTH) do
          Game::Tile.random(weights)
        end
      end

      revealed = Array.new(HEIGHT) { Array.new(WIDTH) { Game::Tile.new(type: :hidden) } }

      new tiles: tiles, revealed: revealed
    end
  end

  def initialize(tiles:, revealed:)
    @tiles    = tiles
    @revealed = revealed
  end

  def to_s
    tiles = @tiles.map { |r| r.join(",") }.join("\n")
    revealed = @revealed.map { |r| r.join(",") }.join("\n")
    "#{tiles}\n\n#{revealed}"
  end
end
