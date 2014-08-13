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

  def send_available_challenges(player)
    challenges = @game.available_challenges(player)
    challenges.each do |c|
      send_message(player.email, c.instructions)
    end
  end
end
