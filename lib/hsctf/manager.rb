class Manager

  def initialize
    # docker is connected to implicitly by require 'docker'
  end

  # takes: yaml hash of challenge
  # side-effects: starts docker file assoc'd with challenge
  # returns: port
  def instance_for(challenge) 
    instance_id = `docker run  -P -d #{challenge['name']} "/bin/bash"`
    port = `docker port #{instance_id} #{challenge['port']}` 
    binding.pry
  end

  # returns a list of challenge_name, port pairs
  # if challenge does not require a docker instance port is 'no_instance'
  def spawn_instances(challenges)
    challenges.map do |name, challenge|
      if challenge["launch_docker_per_user"]
        instance_id, port = instance_for(challenge)
        [name, instance_id, port]
      else
        nil
      end
    end
  end
end
