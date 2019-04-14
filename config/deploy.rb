lock '3.11.0'

set :application, "hybrasyl"
set :repo_url,  "git@github.com:hybrasyl/ealagad.git"

# Default branch is :master
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call
set :bundle_flags, '--deployment --binstubs --quiet'

set :user, "hybrasyl"
set :ssh_options, { :forward_agent => true }
set :deploy_to, "/web/hybrasyl"
set :format, :pretty
set :log_level, :debug
set :pty, true

# Always use a bundled rake
SSHKit.config.command_map[:rake] = "bundle exec rake"

set :branch, "master"
set :keep_releases, 5

set(:current_revision) { capture("cd #{shared_dir}/cached-copy; git rev-parse --short HEAD").strip }
