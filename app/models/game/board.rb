require_relative './tile'
class Game
  # Class representing the gameboard
  # 2D grid of tiles which may be a bomb, number, or unknown
  class Board
    attr_accessor :tiles

    WIDTH = HEIGHT = SIZE = 5

    WEIGHTS = {
      mine: 3,
      one:  4,
      two:  2,
      three: 1
    }.freeze

    class << self
      def random
        tiles = Array.new(HEIGHT) do
          Array.new(WIDTH) { Game::Tile.random(WEIGHTS) }
        end

        build(tiles)
      end

      def build(tiles)
        board = new
        board.tiles = tiles
        board.max_score
        board
      end
    end

    def get_tile(x, y)
      @tiles[y][x]
    rescue
      return nil
    end

    def hidden?(x, y)
      @tiles[y][x].hidden?
    rescue
      return false
    end

    def reveal_tile(x, y)
      tile = get_tile x, y
      tile.reveal unless tile.nil?
      tile
    end

    def to_s
      @tiles.map { |r| r.join(',') }.join("\n")
    end

    def hints
      @hints ||= begin
        rows = Array.new(HEIGHT) { { mines: 0, points: 0 } }
        cols = Array.new(WIDTH) { { mines: 0, points: 0 } }

        set_hints(rows, cols)

        { rows: rows, cols: cols }
      end
    end

    def set_hints(rows, cols)
      @tiles.each_with_index do |row, j|
        row.each_with_index do |tile, i|
          rows[j][:mines] += 1 if tile.mine?
          cols[i][:mines] += 1 if tile.mine?
          rows[j][:points] += tile.value
          cols[i][:points] += tile.value
        end
      end
    end

    def reveal_all
      @tiles.each do |row|
        row.each(&:reveal)
      end
    end

    def max_score
      @max_score ||= @tiles.flatten.reduce(1) do |s, t|
        s * (t.value >= 1 ? t.value : 1)
      end
    end
  end
end
