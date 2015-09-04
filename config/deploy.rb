# config valid only for current version of Capistrano
lock '3.4.0'

# Change these lines as needed
set :application, 'launchboard'
set :user, 'deploy'
set :repo_url, "git@git.syncidlabs.com:iq2technologies/collab.git"
set :puma_threads, [1, 5]
set :puma_workers, 2
set :deploy_to, "/home/deploy/#{fetch :application}"
# set :log_level, :info

# DO NOT modify the codes below this line unless you know what you are doing.
set :pty, true
set :use_sudo, false
set :stage, :production
set :deploy_via, :remote_cache

set :linked_dirs, fetch(:linked_dirs, []).push('public/system', 'log')

set :puma_bind, "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{shared_path}/log/puma.error.log"
set :puma_error_log,  "#{shared_path}/log/puma.access.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to true if using ActiveRecord

set :tmp_dir, "#{shared_path}/tmp/"

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
      execute "mkdir #{shared_path}/log -p"
      execute "touch #{shared_path}/log/nginx.access.log"
      execute "touch #{shared_path}/log/nginx.error.log"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/#{fetch :branch}`
        puts "WARNING: HEAD is not the same as origin/#{fetch :branch}"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy:db_seed'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  desc 'Set config/puma.rb-symlink for upstart'
  task :puma_config_ln do
    on roles(:app) do
      execute "ln -s #{shared_path}/puma.rb #{fetch(:deploy_to)}/current/config/puma.rb"
    end
  end

  desc 'Seed the database with seed.rb'
  task :seed_db do
    on roles(:app, :db) do
      within current_path do
        with rails_env: fetch(:stage) do
          execute :rake, 'db:seed'
        end
      end
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
  after  :finishing,    :puma_config_ln

end

# faye config. uncomment this block if you need faye

# set :faye_pid, "#{shared_path}/tmp/pids/faye.pid"
# set :faye_config, "#{current_path}/faye.ru"

# namespace :faye do
#   desc 'Start Faye'
#   task :start do
#     on roles(:faye) do
#       within current_path do
#         execute :bundle, "exec rackup #{fetch :faye_config} -s puma -E production -D --pid #{fetch :faye_pid}"
#       end
#     end
#   end

#   desc 'Stop Faye'
#   task :stop do
#     on roles(:faye) do
#       execute :kill, "`cat #{fetch :faye_pid}` || true"
#     end
#   end

#   before 'deploy:updating', 'faye:stop'
#   after 'deploy:published', 'faye:start'
# end
