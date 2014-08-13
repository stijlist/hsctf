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
    @players << { 'name' => player_name, 'email' => player_email,
                  'available_challenges' => @root_challenges.dup,
                  'score' => 0 }
  end

  def add_root_challenge(challenge_path)
    @root_challenges << load_challenge(challenge_path)
    self
  end

  def get_children(challenge)
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

  # we could obviate this method by being explicit about the filenames
  # in each challenge yaml file
  def get_child_paths(challenge)
    challenge.fetch('children').map {|challenge_name| "#{challenge_name}.yaml" }
  end

  def submit_answer(player, challenge, answer)
    if challenge.fetch('password') == answer
      player['score'] += challenge['points'] # should scores be a constant? should they vary per challenge?
      # remove the challenge from player.available_challenges, replace with its
      # children
      player['available_challenges'].map! do |c|
        c == challenge ? get_children(c) : challenge
      end.flatten!
    end
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
