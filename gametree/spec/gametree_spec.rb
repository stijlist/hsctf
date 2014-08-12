require_relative '../gametree.rb'

describe Challenge do
  it 'can be initialized from yaml' do
    expect(Challenge.new('../alpha.yaml').data).not_to be_nil

  end

  it 'knows its children' do
    challenge = Challenge.new('../alpha.yaml')
    expect(challenge.child_paths).to eq(['lovelace1.yaml', 'mccarthy1.yaml']) 
  end
end

describe Game do
  before(:each) { @challenge = Challenge.new('../alpha.yaml') }

  it 'must be initialized with a root challenge' do
    expect { Game.new }.to raise_error(ArgumentError)
  end

  it 'has no players when initialized' do
    expect(Game.new(@challenge).players).to be_empty
  end

  it 'can add new challenges' do
    game = Game.new(@challenge)
    expect(game.root).not_to be_nil
  end

  it 'can add new players' do
    game = Game.new(@challenge)
    game.add_player('bert')
    expect(game.players).not_to be_empty
  end
  
end

describe Player do
  before(:each) { @challenge = Challenge.new('../alpha.yaml') }

  it 'knows what game it\'s playing' do
    game = Game.new(@challenge)
    player = game.add_player('bert')
    expect(player.game).to eq(game)
  end

  it 'starts on the first challenge' do
    game = Game.new(@challenge)
    player = game.add_player('bert')
    expect(player.current_challenges).to eq(game.root)
  end

  it 'can submit an answer for the challenge it\'s on' do
    game = Game.new(@challenge)
    player = game.add_player('bert')
    player.submit_answer('nevergraduate!')
    expect( player.current_challenges ).not_to eq(@challenge)
  end
end
