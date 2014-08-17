require 'yaml'
require 'sequel'

class Game
  DATA_DIR = "#{File.dirname(__FILE__)}/../../assets/game_data/"
  DB_PATH = "#{File.dirname(__FILE__)}/../../db/game_database.db"
  # challenges and players are both just data (dictionaries)
  # players keep references to their challenges
  # challenges know which challenges are their children
  attr_accessor :players, :root_challenges
  def initialize
    @DB = Sequel.sqlite(DB_PATH)
    @players = @DB[:players]
    @root_challenges = []
   
    #TODO load all challenges, validate data
  end

  # this tells us what docker instances need to be spun up
  def active_challenges
    @players.all.flat_map { |p| p[:available_challenges].from_yaml }.uniq
  end
  
  def register(player_name, player_email)
    player = { name: player_name, email: player_email,
               available_challenges: @root_challenges.dup.to_yaml,
               score: 0}
    player_id = @players.insert(player)
    
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
    @players.where(attributes).first
  end

  def available_for_player?(player, challenge)
    challenges = YAML.load(player[:available_challenges]).map{|c| c['name']}
    challenges.include? challenge
  end

  # we could obviate this method by being explicit about the filenames
  # in each challenge yaml file
  def get_child_paths(challenge)
    challenge.fetch('children').map {|challenge_name| "#{challenge_name}.yaml" }
  end

  # returns a conditional re: success & updates player's available challenges
  def submit_answer!(player, challenge_name, answer)
    available_challenges =  YAML.load(player[:available_challenges])
    challenge = available_challenges.detect {|c| c['name'] == challenge_name }
    if challenge and challenge['password'] == answer
      available_challenges.delete(challenge)
      available_challenges.concat(get_children(challenge))
      @players.where(id: player[:id]).update(available_challenges: available_challenges.to_yaml, score: player[:score] + challenge['points'])
      return true
    end
    puts answer, challenge.inspect
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

  def score_for(player)
    find_player_by(id: player[:id])[:score]
  end

end
