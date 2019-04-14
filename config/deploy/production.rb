set :rails_env, "production"

server '185.111.201.34', user: fetch(:user), roles: %w{web app db}, primary: true
