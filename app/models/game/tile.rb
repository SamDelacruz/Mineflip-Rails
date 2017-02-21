class Game
  # Class representing a game tile
  # May have a type and value
  # Contains convenience method for assigning a value randomly
  # based on given set of type weights.
  class Tile
    TYPES = {
      bomb: 0,
      one: 1,
      two: 2,
      three: 3,
      hidden: 0
    }.freeze

    class << self
      def random(weights)
        r = rand
        tw = weights.values.reduce { |sum, w| sum + w }.to_f
        nweights = weights.map { |k, w| [k, w / tw] }.to_h
        nweights.each do |k, w|
          return new(type: k) if r < w
          r -= w
        end
      end
    end

    def initialize(type:)
      raise "Invalid tile type #{type}" unless TYPES.key? type
      @type = type
    end

    def value
      TYPES[@type]
    end

    def hidden?
      @type == :hidden
    end

    def bomb?
      @type == :bomb
    end

    def to_s
      case @type
      when :bomb   then 'x'
      when :one    then '1'
      when :two    then '2'
      when :three  then '3'
      when :hidden then '?'
      end
    end

    def as_json(*)
      to_s
    end
  end
end
