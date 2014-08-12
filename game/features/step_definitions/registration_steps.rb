require_relative '../../lib/game.rb'

Given(/^that I have not registered$/) do
  @game = Game.new(Challenge.new)
end

When(/^I pm hsctf 'register'$/) do
    @player = Player.new('Bert Muthalaly', 'bert@somethingdoneright.net')
    @game.register(@player)
end

Then(/^I should be registered$/) do
    expect(@game.has_player?(@player)).to be_truthy
end
