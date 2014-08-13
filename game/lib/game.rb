class Game
  attr_reader :players
  def initialize(path)
    @players = []
    @root = Challenge.new(path)
    
  end

  def register(player)
    @players << player
  end

  def has_player?(player)
    @players.include?(player)
  end
end

class Challenge
  def initialize(path)
    @data = YAML.load(path)
    @
  end
end
