set :user, "hybrasyl"
set :ssh_options, { :forward_agent => true }
set :deploy_to, "/web/hybrasyl.com"

set :scm, :git
set :branch, "master"
set :deploy_subdir, "hybrasyl-rails"
set :rails_env, "production"
set :use_sudo, false

set(:current_revision) { capture("cd #{shared_dir}/cached-copy; git rev-parse --short HEAD").strip }

role :web, "www.hybrasyl.com"
role :app, "www.hybrasyl.com"
role :db,  "www.hybrasyl.com", :primary => true

