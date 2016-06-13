# This file is used by Rack-based servers to start the application.
# $PORT = 3000
# $RAILS_ENV = "development"
require ::File.expand_path('../config/environment', __FILE__)
run Rails.application
