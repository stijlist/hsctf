require_relative '../game.rb'

describe Game do
  let(:game) { Game.new.add_root_challenge('alpha.yaml') }
  let(:max) { game.register('max', 'maxim@ontoillogical.net') }
  let(:first_challenge) { game.root_challenges.first }

  it 'reads challenge objects from the data dir correctly' do
    expect(game.root_challenges).not_to be_empty
  end

  it 'registers players' do
    expect(game.players).to include(max)
  end

  it 'sets players\' initial scores to zero' do
    expect(max['score']).to eq(0)
  end

  it 'knows a challenge\'s children' do
    next_challenges = [game.load_challenge('lovelace1.yaml'), 
                       game.load_challenge('mccarthy1.yaml')]
    expect(game.get_children(first_challenge)).to eq(next_challenges)
  end

  it 'knows if a challenge is available for a given player' do
    expect(game.available_for_player?(max, first_challenge)).to be_truthy
  end

  it 'updates challenges for a player when that player solves a challenge' do
    game.submit_answer!(max, first_challenge['name'], 'nevergraduate!')
    next_challenges = game.get_children(first_challenge)
    expect(max.fetch('available_challenges')).to eq(next_challenges)
  end

  it 'knows when a player has solved a challenge' do
    expect(game.submit_answer!(max, first_challenge['name'], 'nevergraduate!')).to be_truthy
  end

  it 'updates scores for a player when a player solves a challenge' do
    game.submit_answer!(max, first_challenge['name'], 'nevergraduate!')
    expect(max.fetch('score')).to eq(first_challenge['points'])
  end

  it 'knows which challenges are currently active without duplicates' do
    game.register('bert', 'bert@somethingdoneright.net')
    expect(game.active_challenges).to eq([first_challenge])
  end

  it 'knows about all challenges accessible from root challenges' do
    all_challenges_expected = [first_challenge,
                               game.load_challenge('lovelace1.yaml'),
                               game.load_challenge('mccarthy1.yaml')]
    expect(game.all_challenges).to eq(all_challenges_expected)
  end
end
