require 'yaml'

class Game
  def initialize(path)
    @players = {}
    @root = Challenge.new(path)
  end

  def players
    @players.values
  end
  def register(player)
    @players[player.name] = player
  end

  def has_player?(player)
    @players[player.name] != nil
  end

  def lookup(player_name)
    @players[player_name]
  end

  def available_challenges(player)
    [@root]
  end
end

class Challenge
  def initialize(path)
    @data = YAML.load(path)
  end

  def instructions
    @data['text']
  end
end
