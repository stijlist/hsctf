require 'yaml'
require 'sequel'
require 'pry'

class Game
  DATA_DIR = "#{File.dirname(__FILE__)}/../../assets/game_data/"
  DB_PATH = "#{File.dirname(__FILE__)}/../../db/game_database.db"
  # challenges and players are both just data (dictionaries)
  # players keep references to their challenges
  # challenges know which challenges are their children
  attr_accessor :players, :challenges, :root_challenge
  def initialize
    @DB = Sequel.sqlite(DB_PATH)
    @players = @DB[:players]
    challenge_info = YAML.load_file(File.join(DATA_DIR, "challenges.yaml"))
    @root_challenge = challenge_info['root']
    @challenges = {}
    challenge_info["challenges"].each do |name, path|
      @challenges[name] = YAML.load_file(File.join(DATA_DIR, path))
    end
   
    #TODO validate data
  end

  def register(player_name, player_email)
    player = { name: player_name, email: player_email,
               available_challenges: [@root_challenge].to_yaml,
               score: 0}
    player_id = @players.insert(player)
    player_id
  end
 
  def get_children(challenge)
    unless challenge.is_a? Hash
      challenge = @challenges[challenge]
    end
    challenge["children"]
  end

  def find_player_by(attributes)
    @players.where(attributes).first
  end

  def available_for_player?(player, challenge)
    challenges = YAML.load(player[:available_challenges])
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
    if available_challenges.include? challenge_name
      challenge = @challenges[challenge_name]
      if challenge and challenge['password'] == answer
        available_challenges.delete(challenge_name)
        available_challenges.concat(get_children(challenge))
        @players.where(id: player[:id]).update(available_challenges: available_challenges.to_yaml, score: player[:score] + challenge['points'])
        return true
      end
    end
    false
  end

  def score_for(player)
    find_player_by(id: player[:id])[:score]
  end

end
