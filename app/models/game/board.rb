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

        board = new
        board.tiles = tiles
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
  end

  # Class representing a game tile
  # May have a type and value
  # Contains convenience method for assigning a value randomly
  # based on given set of type weights.
  class Tile
    TYPES = {
      mine: 0,
      one: 1,
      two: 2,
      three: 3
    }.freeze

    attr_accessor :type, :hidden

    class << self
      def random(weights)
        r = rand
        tw = weights.values.reduce { |sum, w| sum + w }.to_f
        nweights = weights.map { |k, w| [k, w / tw] }.to_h
        nweights.each do |k, w|
          return new(type: k, hidden: true) if r < w
          r -= w
        end
      end

      attr_reader :TYPES
    end

    def initialize(type:, hidden:)
      raise "Invalid tile type #{type}" unless TYPES.key? type
      @type = type
      @hidden = hidden
    end

    def value
      TYPES[@type]
    end

    def hidden?
      @hidden
    end

    def reveal
      @hidden = false
      self
    end

    def mine?
      @type == :mine
    end

    def to_s
      return '?' if hidden?
      case @type
      when :mine   then '*'
      when :one    then '1'
      when :two    then '2'
      when :three  then '3'
      end
    end

    def as_json(*)
      to_s
    end
  end
end
