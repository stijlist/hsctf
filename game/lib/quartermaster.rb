require_relative "game.rb"
require 'zulip'

class Quartermaster
  def initialize(game, zulip)
    @zulip = zulip
    @game = game
  end
  
  def send_message(player, message)
    @zulip.send_private_message(message, player.email)
  end

  def send_available_challenges(player_name)
    player = @game.lookup(player_name)
    unless player.nil?
      challenges = @game.available_challenges(player)
      challenges.each do |c|
        send_message(player, c.instructions)
      end
    end
  end
end
