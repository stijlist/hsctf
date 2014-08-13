require_relative '../lib/game.rb'

describe Game do
  it "knows when a player is registered" do
    game = Game.new(nil)
    player = Player.new(nil, nil)
    game.register(player)
    expect(game.has_player?(player)).to be_truthy
  end

  it "knows its players" do
    game = Game.new(nil)
    player1 = Player.new(nil, nil)
    player2 = Player.new(nil, nil)
    game.register(player1)
    game.register(player2)
    expect(game.players).to eq([player1, player2])
  end
end
