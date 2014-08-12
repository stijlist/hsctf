require 'zulip'
require 'yaml'
require 'pry'

# zulip = Zulip::Client.new do |config|
#   config.email_address = ENV.fetch( 'ZULIP_HSCTF_API_KEY' )
#   config.api_key = ENV.fetch( 'ZULIP_HSCTF_EMAIL' )
# end

# ctf_stream = 'hs-ctf'

# zulip.subscribe ctf_stream

# zulip.send_message 'urgent message', 'started', ctf_stream

# the zulip bot builds up a graph of the game tree 
class Player 
  attr_accessor :name, :game, :current_challenges
  def initialize(name, game, current_challenges)
    @name = name
    @game = game 
    @current_challenges = current_challenges
  end
  
end

class Game
  attr_accessor :players, :root
  def initialize(root_challenge)
    @root = root_challenge
    @players = []
  end

  def add_player(name)
    player = Player.new(name, self, @root)
    @players << player
    player
  end
end

class Challenge
  attr_accessor :data, :password

  def initialize(yaml_filename)
    @data = parse_yaml(yaml_filename)
    @password = @data['password']
  end

  def children
    child_paths.map{|path| Challenge.new(path) }
  end

  def child_paths
    self.data.fetch('children').map {|challenge| "#{challenge}.yaml" }
  end

  def submit_password(password)
    (@data.fetch('password') == password) ? children : self
  end

  def parse_yaml(relative_path)
    YAML::load(File.open(File.join(File.dirname(__FILE__), relative_path)))
  end

  def ==(other)
    @data == other.data
  end
end
