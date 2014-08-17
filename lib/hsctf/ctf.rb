#!/usr/bin/env ruby
require_relative 'messager.rb'
require_relative 'quartermaster.rb'
class CTF
  def initialize
    @messager = Messager.new
    @game = Game.new.add_root_challenge('alpha.yaml')
    @quartermaster = Quartermaster.new(@game, @messager)
    @messager.listen do |message|
      if message.type == 'private' && message.sender_email != "hsctf-bot@students.hackerschool.com" # TODO: probably not the correct check for pms
        puts "Got a message #{message.inspect}"
        @quartermaster.receive_pm(message.sender_full_name, message.sender_email, message.content)
      end
    end
  end
end
