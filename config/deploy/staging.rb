set :user, "stage-hybrasyl"
set :ssh_options, { :forward_agent => true }
set :deploy_to, "/web/stage.hybrasyl.com"

set :scm, :git
set :branch, "master"
set :rails_env, "staging"
set :use_sudo, false

set(:current_revision) { capture("cd #{shared_dir}/cached-copy; git rev-parse --short HEAD").strip }

role :web, "stage.hybrasyl.com"
role :app, "stage.hybrasyl.com"
role :db,  "stage.hybrasyl.com", :primary => true

