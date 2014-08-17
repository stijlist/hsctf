
# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'hsctf'
set :repo_url, 'git@github.com:stijlist/hsctf.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/deploy/app'

set :use_sudo, false
set :ssh_options, { forward_agent: true }
set :deploy_via, :remote_cache
set :user, "deploy"

set :bundle_bins, fetch(:bundle_bins, []).push("./bin/create_db")


# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{db/game_database.db logs/hsctf.log config/env.yml}
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  desc 'Starting application'
  task :start do 
    on roles(:app) do
      within current_path do
        execute *%w[bundle exec bin/hsctf -d]
      end
    end
  end
 
  desc 'Stoppining application'
  task :stop do
    on roles(:app) do
      within current_path do
        execute *%w[bundle exec bin/hsctf -d -k]
      end
    end
  end
  
  desc 'Restarting application'
  task :restart do
    on roles(:app), in: :sequence do
      invoke("deploy:stop")
      invoke("deploy:start")
    end
  end

  after :deploy, "deploy:restart"
end

namespace :db do
  desc 'Create Database'
  task :create do
    on roles(:app) do
      execute "cd #{current_path} && bundle exec ./bin/create_db"
    end
  end
end

namespace :message do
  desc 'Announcement'
  task :announce, :message do |t, args|
    on roles(:app) do
      within current_path do
        execute *%W[bundle exec bin/announce "#{args[:message]}"]
      end
    end
  end
end

namespace :message do
  desc 'Private Message'
  task :pm, :email, :message do |t, args|
    on roles(:app) do
      within current_path do
        execute *%W[bundle exec bin/announce "#{args[:email]}" "#{args[:message]}"]
      end
    end
  end
end
 



