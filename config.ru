require './app'
if ENV['RACK_ENV'] == "development"
  require 'rack-livereload'
  use Rack::LiveReload
end
run Sinatra::Application