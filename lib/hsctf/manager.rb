require 'docker'

class Manager

  def initialize
    # docker is connected to implicitly by require 'docker'
  end

  # takes: yaml hash of challenge
  # side-effects: starts docker file assoc'd with challenge
  # returns: port
  def instance_for(challenge) 
    image = Docker::Image.build(challenge["dockerfile"])
    binding.pry
    port = image.run(challenge["run_cmd"]).connection.url.split(':').last
    port
  end

  # returns a list of challenge_name, port pairs
  # if challenge does not require a docker instance port is 'no_instance'
  def spawn_instances(challenges)
    challenges.map do |name, challenge|
      if challenge["dockerfile"]
        [name, instance_for(challenge)]
      else
        [name, nil]
      end
    end
  end
end
