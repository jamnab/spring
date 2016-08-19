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

set :linked_dirs, fetch(:linked_dirs, []).push('public/system', 'log', 'public/images', 'public/uploads', 'vendor/bundle')
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secret.yml')

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

set :slack_msg_starting,     -> { "#{ENV['USER'] || ENV['USERNAME']} has started deploying branch #{fetch :branch} of #{fetch :application} to #{fetch :slack_stage, 'an unknown stage'}" }
set :slack_msg_finished,     -> { "#{ENV['USER'] || ENV['USERNAME']} has finished deploying branch #{fetch :branch} of #{fetch :application} to #{fetch :slack_stage, 'an unknown stage'}" }
set :slack_msg_failed,       -> { "#{ENV['USER'] || ENV['USERNAME']} failed to deploy branch #{fetch :branch} of #{fetch :application} to #{fetch :slack_stage, 'an unknown stage'}" }

# slack integration
set :slack_webhook, "https://hooks.slack.com/services/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"

set :rvm1_ruby_version, "ruby-2.2.4"

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

  desc "Clear tmp because sync gem doesn't like it otherwise"
  task :tmp_clear do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:stage) do
          execute :rake, 'tmp:clear'
        end
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
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

end


# faye setup. uncomment this if u need
set :faye_pid, "#{shared_path}/tmp/pids/faye.pid"
set :faye_state, "#{shared_path}/tmp/pids/faye.state"
set :faye_config, "#{current_path}/config/puma_faye.rb"


namespace :faye do
  desc 'Start Faye'
  task :start do
    on roles(:faye) do
      within current_path do
        with rails_env: fetch(:stage) do
          # faye must be run on production
          # execute :bundle, :exec, "puma --config #{fetch :faye_config} -d"
          # execute :bundle, :exec, :rackup, "#{current_path}/sync.ru -D -s puma -E production --pid #{fetch :faye_pid} -O Threads=1:5"
          # if fetch(:slack_stage) == 'staging'
          execute :bundle, :exec, :rackup, "#{current_path}/sync.ru -E production -s thin --pid #{fetch :faye_pid} -D"
          # else
          #   execute :bundle, :exec, :thin, "-C #{current_path}/config/sync_thin.yml start"
          # end
        end
      end
    end
  end

  desc 'Stop Faye'
  task :stop do
    on roles(:faye) do
      execute :kill, "`cat #{fetch :faye_pid}` || true"
    end
  end

  desc 'Restart Faye'
  task :restart do
    on roles(:faye) do
      within current_path do
        with rails_env: fetch(:stage) do
          invoke "faye:stop"
          invoke "faye:start"
          # execute :bundle, :exec, :pumactl, "-S #{fetch(:faye_state)} -F #{fetch :faye_config} restart"
        end
      end
    end
  end

  desc 'Move sync config file from gist'
  task :config do
    on roles(:faye) do
      execute :curl, "-o #{current_path}/config/sync.yml -L #{fetch :sync_yml_url}"
    end
  end

  after 'deploy:published', 'faye:config'
  after 'faye:config', 'faye:restart'
end

namespace :azure do
  desc 'Azure sql server config'
  task :sql_config do
    on roles(:app) do
      if fetch(:slack_stage) == "production"
        execute :curl, "-o #{shared_path}/config/database.yml -L #{fetch :database_yml_url}"
      end
    end
  end

  after 'deploy:started', 'azure:sql_config'
end

namespace :console do
  desc 'Dump the database data to download later'
  task :dump_db do
    on roles(:db) do
      within current_path do
        with rails_env: fetch(:stage) do
          execute :bundle, :exec, :rake, 'db:data:dump'
        end
      end
    end
  end
end

namespace :ftp do
  desc 'Download the dumped data.yml. NOTE: Execute this in the project root directory!!!'
  task :download_db do
    on roles(:db) do
      within current_path do
        download! "#{current_path}/db/data.yml", "db/data.yml"
      end
    end
  end
end
p
