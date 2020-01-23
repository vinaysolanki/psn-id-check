require './app'
require 'rack-livereload'
use Rack::LiveReload if ENV['RACK_ENV'] == "development"
run Sinatra::Application