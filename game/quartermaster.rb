require 'pry'
class Quartermaster
  attr_reader :game
  def initialize(game, messager)
    @game = game
    @messager = messager
  end

  def send_message(player, message)
    @messager.send_message(player, message)
  end

  def receive_pm(name, email, text)
    player = @game.find_player_by(email: email)
    unless player
      if text.start_with?('register')
        player = @game.register(name, email)
        send_message(player, "You've successfully registered!")
      else
        send_message({email: email}, "You haven't signed up! Send me a pm with 'register' to sign up.")
      end
    else
      available_challenges = YAML.load(player[:available_challenges])
      case text.split.first.downcase
      when /solved?/
        challenge_name = text.split[1]
        if @game.available_for_player?(player, challenge_name)
          password = text.split[2]
          if @game.submit_answer!(player, challenge_name, password)
            send_message(player, "Excellent, you've completed this mission")
            send_message(player, "Your score is #{@game.score_for(player)}")
            new_challenges =  @game.get_children(challenge_name)
            if new_challenges && !new_challenges.empty?
              if new_challenges.length > 1
                send_message(player, "You have unlocked #{new_challenges.length} new missions")
              else
                send_message(player, "You have unlocked a new mission")
              end
              new_challenges.each do |c|
                send_challenge_description(c, player)
              end
            else
              if player[:available_challenges].empty?
                send_message(player, "Congratulations, you've finished the Hacker School CTF")
                #TODO alert stream that player is done
              end
            end
            
          #TODO handle winning
          #TODO: update leaderboard, act accordingly
          else
            send_message(player,
                         "That didn't work. Try again, time is of the essence!")
          end
        else
          send_message(player,
                       "I don't know about that challenge yet. Do you have access to it?")
        end
      when 'score'
        send_message(player, "Your score is #{@game.score_for(player)}")
      when 'challenges'
        available_challenges.each do |c|
          send_challenge_description(c, player)
        end
      when 'show'
        challenge_name = text.split[1]
        challenge = available_challenges.detect do |c|
          c['name'] = challenge_name
        end
        if challenge
          send_challenge_description(challenge, player)
        end
      when 'help'
        helptext = <<-EOS
You can
1. `help` - see a help screen
2. `score` - view your score
3. `solve <LEVEL NAME> <PASSWORD>`
4. `challenges` - message you all available challenges
5. `show <CHALLENGE>` - pm you the description of <CHALLENGE>
EOS

        send_message(player, helptext)
      else
        send_message(player, "I didn't understand that. PM me 'help' for commands")
      end
    end
  end

  def send_challenge_description(challenge, player)
    send_message(player, "**#{challenge['name']}**")
    if challenge['exec']
      interpolated_values = eval(challenge['exec'])
    else
      interpolated_values = {}
    end
    send_message(player, challenge['text'] % interpolated_values)
  end

end
