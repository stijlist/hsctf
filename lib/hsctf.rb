require 'hsctf/game.rb'
require 'hsctf/ctf.rb'
require 'hsctf/quartermaster'
require 'hsctf/messager'
require 'hsctf/manager'

env_file = File.join(File.dirname(__FILE__), '../config', 'env.yml')
YAML.load(File.open(env_file)).each do |key, value|
  ENV[key.to_s] = value
end if File.exists?(env_file)
