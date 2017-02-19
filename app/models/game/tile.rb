class Game::Tile
  TYPES = {
    bomb: 0,
    one: 1,
    two: 2,
    three: 3,
    hidden: 0
  }

  class << self
    def random(weights)
      r = rand()
      tw = weights.values.reduce { |sum, w| sum + w }.to_f
      nweights = weights.map { |k, w| [ k, w / tw ] }.to_h
      type = nweights[nweights.keys.first]
      nweights.each do |k, w|
        if r < w
          return new(type: k)
        end
        r -= w
      end
    end
  end

  def initialize(type:)
    if !TYPES.has_key? type
      raise "Invalid tile type #{type}"
    end

    @type = type
  end

  def value
    TYPES[@type]
  end

  def is_hidden?
    @type == :hidden
  end

  def is_bomb?
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
end
