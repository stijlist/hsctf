require_relative './game.rb'

describe Game do
  it 'reads challenge objects from the data dir correctly' do
    game = Game.new.add_root_challenge('alpha.yaml')
    expect(game.root_challenges).not_to be_empty
  end

  it 'registers players with a score of zero' do
    game = Game.new.add_root_challenge('alpha.yaml')
    game.register('max', 'maxim@ontoillogical.net')
    expect(game.players.map {|p| p['name'] }).to include('max')

  end
end
