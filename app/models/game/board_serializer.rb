require 'enumerator'
class Game
  # Serializer for encoding / decoding game boards in a string
  class BoardSerializer
    DELIM = ','.freeze
    W = Board::WIDTH
    H = Board::HEIGHT

    def self.load(data)
      return Board.new if data.nil?
      Board.build(tiles(data))
    end

    def self.dump(board)
      board.tiles.flatten.map do |t|
        "#{t.value}#{revealed_s(t)}"
      end.join(',')
    end

    def self.tiles(str)
      ts = str.split(DELIM).each_slice(W)
      ts.map do |row|
        row.map do |tstr|
          t = Tile::TYPES.key(tstr[0].to_i)
          h = tstr[-1] != '!'
          Tile.new(type: t, hidden: h)
        end
      end.to_a
    end

    def self.revealed_s(t)
      t.hidden? ? '' : '!'
    end
  end
end
