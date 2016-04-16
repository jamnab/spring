# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'
#
require 'rvm1/capistrano3'
require 'capistrano/bundler'

require 'capistrano/rails'
require 'capistrano/puma'
require 'capistrano/puma/nginx'
require 'capistrano/puma/monit'

require 'whenever/capistrano'

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }

desc "Check that we can access everything"
task :check_write_permissions do
  on roles(:all) do |host|
    if test("[ -w #{fetch(:deploy_to)} ]")
      info "#{fetch(:deploy_to)} is writable on #{host}"
    else
      error "#{fetch(:deploy_to)} is not writable on #{host}"
    end
  end
end
