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

    def get_tile(x, y)
      @tiles[y][x]
    rescue
      return nil
    end

    def hidden?(x, y)
      @revealed[y][x].hidden?
    rescue
      return false
    end

    def reveal_tile(x, y)
      tile = get_tile x, y
      @revealed[y][x] = tile unless tile.nil?
    end

    def to_s
      tiles = @tiles.map { |r| r.join(',') }.join("\n")
      revealed = @revealed.map { |r| r.join(',') }.join("\n")
      "#{tiles}\n\n#{revealed}"
    end

    def hints
      @hints ||= begin
        rows = Array.new(HEIGHT) { { mines: 0, points: 0 } }
        cols = Array.new(WIDTH) { { mines: 0, points: 0 } }

        @tiles.each_with_index do |row, j|
          row.each_with_index do |tile, i|
            rows[j][:mines] += 1 if tile.bomb?
            cols[i][:mines] += 1 if tile.bomb?
            rows[j][:points] += tile.value
            cols[i][:points] += tile.value
          end
        end

        { rows: rows, cols: cols }
      end
    end
  end
end
