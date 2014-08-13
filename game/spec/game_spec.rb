require_relative '../game.rb'

describe Game do
  let(:game) { Game.new.add_root_challenge('alpha.yaml') }
  let(:max) {
    game.register('max', 'maxim@ontoillogical.net')
    game.find_player_by('name' => 'max')
  }
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

  it 'updates challenges for a player when that player solves a challenge' do
    game.submit_answer(max, first_challenge, 'nevergraduate!')
    next_challenges = game.get_children(first_challenge)
    expect(max.fetch('available_challenges')).to eq(next_challenges)
  end
end
