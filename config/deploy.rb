
set :application, 'suspend'
set :repo_url, 'git@github.com:codeglover/suspend.git'
set :use_sudo, false
set :deploy_via, :copy
set :keep_releases, 2
set :log_level, :debug
set :pty, false
# RVM 1 Settings
append :rvm1_map_bins, 'rake', 'gem', 'bundle', 'ruby', 'puma', 'pumactl', 'yarn', 'node'
set :rvm1_ruby_version, 'ruby-3.0.0'
set :rvm_type, :user
set :rvm1_map_bins, %w{rake gem bundle ruby puma pumactl yarn node}
set :default_env, {
    rvm_bin_path: '~/.rvm/bin',
}
set :linked_files, ['config/database.yml', 'config/master.key']
set :linked_dirs, ['log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'tmp/uploads/cache', 'tmp/uploads/store']
set :assets_dependencies, %w(app/assets lib/assets vendor/assets config/routes.rb)
namespace :assets do
  task :backup_manifest do
    on roles(fetch(:assets_roles)) do
      within release_path do
        execute :cp,
                release_path.join('public', fetch(:assets_prefix), '.sprockets-manifest*'),
                release_path.join('assets_manifest_backup')
      end
    end
  end
end

namespace :deploy do
  task :delete_public_assets_shared do
    on roles(:web) do
      execute("rm -rf /home/ubuntu/www/rails6/shared/public/assets")
    end
  end
  task :delete_public_assets do
    on roles(:web) do
      within release_path do execute("rm -rf public/assets")
      end
    end
  end
  before "git:wrapper", "deploy:delete_public_assets_shared"
  before "bundler:install", "deploy:delete_public_assets"
  desc 'Uploads required config files'
  task :upload_configs do
    on roles(:all) do
      upload!(".env.#{fetch(:stage)}", "#{deploy_to}/shared/.env")
    end
  end
  desc 'Seeds database'
  task :seed do
    on roles(:app) do
      invoke 'rvm1:hook'
      within release_path do
        execute :bundle, :exec, :"rake db:setup RAILS_ENV=#{fetch(:stage)}"
      end
    end
  end
# before 'deploy:migrate', 'deploy:create_db'
# after :finished, 'app:restart'
  after :finished, 'puma:restart'
  after :finished, 'puma:start'
end
namespace :app do
  desc 'Start application'
  task :start do
    on roles(:app) do
      invoke 'rvm1:hook'
      within "#{fetch(:deploy_to)}/current/" do
        execute :bundle, :exec, :"puma -C config/puma.rb -e #{fetch(:stage)}"
      end
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:app) do
      invoke 'rvm1:hook'
      within "#{fetch(:deploy_to)}/current/" do
        execute :bundle, :exec, :'pumactl -F config/puma.rb stop'
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app) do
      invoke 'rvm1:hook'
      within "#{fetch(:deploy_to)}/current/" do
        if test("[ -f #{deploy_to}/current/tmp/pids/puma.pid ]")
          execute :bundle, :exec, :'pumactl -F config/puma.rb stop'
        end

        execute :bundle, :exec, :"puma -C config/puma.rb -e #{fetch(:stage)}"
      end
    end
  end
end