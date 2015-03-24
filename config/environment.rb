# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Hybrasyl::Application.initialize!

# Try go get our git version

c = File.join(Rails.root, "public/hybrasyl-commit")

HYBRASYL_REVISION = `cat #{c}`.strip unless !File.exists? c
