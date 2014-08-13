require_relative "../lib/quartermaster.rb"
require_relative '../lib/game.rb'
require_relative '../lib/player.rb'
require 'zulip'


describe Quartermaster do
  before(:each) do
    @zulip = double()
   
    @player = Player.new("Max Veytsman", "maxim@ontoillogical.com")
    @game = Game.new("alpha.yaml")
    @game.register(@player)
    @qm = Quartermaster.new(@game, @zulip)
  end
  
  it "can PM a user" do
    message = "Welcome to the game!"
    expect(@zulip).to receive(:send_private_message).with(message, @player.email)
    @qm.send_message(@player, message)
  end

  it "can send a their current challenges" do
    
    expect(@zulip).to receive(:send_private_message).with(YAML.load("../game_data/alpha.yaml")["instructions"], @player.email)
    @qm.send_available_challenges(@player)
  end
end
