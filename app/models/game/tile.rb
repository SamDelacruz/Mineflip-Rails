class Game
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

    def safe?
      !mine?
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
