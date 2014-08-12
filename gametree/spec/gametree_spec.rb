require_relative '../gametree.rb'

describe Game do
  before(:each) do
    @challenge = Challenge.new('alpha.yaml') 
    @game = Game.new(@challenge)
    @player = @game.add_player('bert')
  end

  it 'must be initialized with a root challenge' do
    expect { Game.new }.to raise_error(ArgumentError)
  end

  it 'has no players when initialized' do
    expect(Game.new(@challenge).players).to be_empty
  end

  it 'can add new players' do
    game = Game.new(@challenge)
    game.add_player('bert')
    expect(game.players).not_to be_empty
  end

  it 'allows players to submit answer to challenges' do
    game = Game.new(players: ['bert'], root_challenge: 'alpha.yaml')
    game = game.submit_password(challenge: 'alpha', password: 'nevergraduate!')
    expect(game.players.fetch('bert')).score 
  end

  it 'awards points to users for challenges solved'
  it 'keeps track of who is leading'
  it 'can launch containers for new challenges'
end
















describe Challenge do
  it 'can be initialized from yaml' do
    expect(Challenge.new('alpha.yaml').data).not_to be_nil
  end

  it 'knows its children' do
    challenge = Challenge.new('alpha.yaml')
    expect(challenge.children).to eq([Challenge.new('lovelace1.yaml'), Challenge.new('mccarthy1.yaml')]) 
  end

  it 'knows its password' do
    challenge = Challenge.new('alpha.yaml')
    expect( challenge.password ).to eq('nevergraduate!')
  end
end


describe Player do
  before(:each) { @challenge = Challenge.new('alpha.yaml') }

  it 'knows what game it\'s playing' do
    game = Game.new(@challenge)
    player = game.add_player('bert')
    expect(player.game).to eq(game)
  end

  it 'starts on the root challenge' do
    game = Game.new(@challenge)
    player = game.add_player('bert')
    expect(player.current_challenges).to eq(game.root)
    # accessible challenges
  end

  it 'can submit an answer for the challenge it\'s on' do
    game = Game.new(@challenge)
    player = game.add_player('bert')
    player.submit_password('nevergraduate!')
    expect( player.current_challenges ).not_to eq(@challenge)
    expect( player.current_challenges ).to eq(@challenge.children)
  end

end
