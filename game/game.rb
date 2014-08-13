require 'yaml'

class Game
  DATA_DIR = 'game_data/'
  # challenges and players are both just data (dictionaries)
  # players keep references to their challenges
  # challenges know which challenges are their children
  attr_accessor :players, :root_challenges
  def initialize
    @players = []
    @root_challenges = []
  end

  # this tells us what docker instances need to be spun up
  def active_challenges
    @players.flat_map {|p| p['available_challenges'] }.uniq
  end
  
  def register(player_name, player_email)
    player = { 'name' => player_name, 'email' => player_email,
                  'available_challenges' => @root_challenges.dup,
                  'score' => 0 }
    @players << player
    player
  end

  def add_root_challenge(challenge_path)
    @root_challenges << load_challenge(challenge_path)
    self
  end

  def get_children(challenge)
    unless challenge.is_a? Hash
      challenge = all_challenges.detect{|c| c['name'] == challenge}
    end
    get_child_paths(challenge).map do |c| 
      load_challenge(c)
    end
  end

  def load_challenge(challenge)
    YAML.load(File.read(File.join(DATA_DIR, challenge)))
  end

  def find_player_by(attributes)
    @players.detect do |p| 
      attributes.keys.all? {|k| p[k] == attributes[k] }
    end
  end

  def available_for_player?(player, challenge)
    player['available_challenges']
  end

  # we could obviate this method by being explicit about the filenames
  # in each challenge yaml file
  def get_child_paths(challenge)
    challenge.fetch('children').map {|challenge_name| "#{challenge_name}.yaml" }
  end

  # returns a conditional re: success & updates player's available challenges
  def submit_answer!(player, challenge_name, answer)
    challenge = player['available_challenges'].detect {|c| c['name'] == challenge_name }
    if challenge and challenge['password'] == answer
      player['available_challenges'].delete(challenge)
      player['available_challenges'].concat(get_children(challenge))
      player['score'] += challenge['points']
      return true
    end
    false
  end

  def all_challenges
    @root_challenges.map {|c| all_children(c) }.flatten.uniq
  end

  def all_children(challenge)
    # probably suboptimal lolol
    get_children(challenge).reduce([challenge]) do |acc, c| 
      acc << c 
      acc << all_children(c) 
    end.flatten
  end

end
