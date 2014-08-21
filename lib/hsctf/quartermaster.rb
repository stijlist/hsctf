require 'pry'
class Quartermaster
  attr_reader :game
  def initialize(game, messager)
    @game = game
    @messager = messager
    @leaders = []
  end

  def send_message(player, message)
    @messager.send_message(player, message)
  end

  def receive_pm(name, email, text)
    # check that player exists already in-game
    player = @game.find_player_by(email: email)
    unless player
      # check that unregistered players are trying to register
      if text.start_with?('register')
        player_id = @game.register(name, email)
        player = @game.find_player_by(id: player_id)
        send_message(player, "You've successfully registered!")
      else
        send_message({email: email}, "You haven't signed up! Send me a pm with 'register' to sign up.")
      end
    else
      # find player's available challenges
      available_challenges = player[:available_challenges]
      case text.split.first.downcase
      when /solved?/
        # if user is trying to solve something 
        challenge_name = text.split[1]
        # if challenge is available for a player
        if @game.available_for_player?(player, challenge_name)
          password = text.split[2]
          # if password is correct
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
              #todo uglyness
              if (game.find_player_by(id: player[:id])[:available_challenges]).empty?
                send_message(player, "Congratulations, you've finished the Hacker School CTF")
                #TODO alert stream that player is done
              end
            end
            
            #TODO: update leaderboard, act accordingly
            if @leaders != @game.leaders
              @leaders = @game.leaders
              @messager.broadcast_message('hsctf', 'Current Leaders', "Currently leading: #{@leaders.map{|l| l[:name]}.join(',').chomp(',')}")
            end

          # if password is incorrect
          else
            send_message(player,
                         "That didn't work. Try again, time is of the essence!")
          end
        # if challenge is not in player's list of challenges
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
        if available_challenges.include? challenge_name
          send_challenge_description(challenge_name, player)
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
    unless challenge.is_a? Hash
      challenge = game.challenges[challenge]
    end
    send_message(player, "**#{challenge['name']}**")
    port = @game.find_challenge_port(player, challenge["name"])
    if challenge['locals']
      locals = eval(challenge['locals'])
    else
      locals = {}
    end
    send_message(player, challenge['text'] % locals)
  end

end
