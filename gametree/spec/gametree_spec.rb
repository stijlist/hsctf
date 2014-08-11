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
