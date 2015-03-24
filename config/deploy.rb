set :application, "hybrasyl"
set :repository,  "git@github.com:baughj/ealagad.git"

set :user, "hybrasyl"
set :ssh_options, { :forward_agent => true }
set :deploy_to, "/web/hybrasyl.com"

set :scm, :git
set :branch, "master"
set :deploy_subdir, "hybrasyl-rails"

set(:current_revision) { capture("cd #{shared_dir}/cached-copy; git rev-parse --short HEAD").strip }

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :commit do
    run "cd #{release_path}; git rev-parse --short HEAD > #{release_path}/public/hybrasyl-commit"
  end

  task :copyconfig do
    run "cp -R #{deploy_to}/private/* #{release_path}"
  end

end

after "deploy", "deploy:migrate"
after "deploy", "deploy:commit"
before "deploy:assets:precompile", "deploy:copyconfig"
