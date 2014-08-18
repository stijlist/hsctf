require_relative '../lib/hsctf/game.rb'

describe Game do
  let(:manager) do 
    double(spawn_instances: [['alpha1', '2375'], ['mccarthy1', '2375'], ['lovelace1', '2375']]) 
  end
  let(:game) { Game.new(manager) }
  let(:max_id) { game.register('max', 'maxim@ontoillogical.net') }
  let(:max) { game.find_player_by(id: max_id ) }
  let(:first_challenge) { game.root_challenge }

  it 'reads challenge objects from the data dir correctly' do
    expect(game.challenges).not_to be_empty
  end

  it 'registers players' do
    expect(game.players).to include(max)
  end

  it 'sets players\' initial scores to zero' do
    max = game.find_player_by(id: max_id)
    expect(max[:score]).to eq(0)
  end

  it 'knows a challenge\'s children' do
    next_challenges = ["lovelace1", "mccarthy1"]
    expect(game.get_children(first_challenge)).to eq(next_challenges)
  end

  it 'knows if a challenge is available for a given player' do
    expect(game.available_for_player?(max, first_challenge)).to be_truthy
  end

  it 'updates challenges for a player when that player solves a challenge' do
    game.submit_answer!(max, first_challenge, 'nevergraduate!')
    max = game.find_player_by(id: max_id)
    next_challenges = game.get_children(first_challenge)
    expect(YAML.load(max[:available_challenges])).to eq(next_challenges)
  end

  it 'knows when a player has solved a challenge' do
    expect(game.submit_answer!(max, first_challenge, 'nevergraduate!')).to be_truthy
  end

  it 'updates scores for a player when a player solves a challenge' do
    game.submit_answer!(max, first_challenge, 'nevergraduate!')
    max =  game.find_player_by(id: max_id)
    expect(max[:score]).to eq(game.challenges[first_challenge]['points'])
  end
end
