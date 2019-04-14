# frozen_string_literal: true

rackup DefaultRackup
environment ENV.fetch('RAILS_ENV', 'development')

workers ENV.fetch('PUMA_WORKERS', 3).to_i
threads ENV.fetch('MIN_THREADS', 1).to_i, ENV.fetch('MAX_THREADS', 10).to_i

bind ENV.fetch('PUMA_BIND_PATH', 'tcp://0.0.0.0:3000')

activate_control_app 'tcp://0.0.0.0:9292', { auth_token: 'ealagad' }
prune_bundler

on_restart do
  puts 'Refreshing Gemfile'
  ENV["BUNDLE_GEMFILE"] = "/web/hybrasyl/current/Gemfile"
end

