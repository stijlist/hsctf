require_relative '../lib/game.rb'

describe Game do
  it "knows when a player is registered" do
    game = Game.new('')
    player = Player.new('', '')
    game.register(player)
    expect(game.has_player?(player)).to be_truthy
  end

  it "knows its players" do
    game = Game.new('')
    player1 = Player.new('bert', '')
    player2 = Player.new('max', '')
    game.register(player1)
    game.register(player2)
    expect(game.players).to eq([player1, player2])
  end
end
