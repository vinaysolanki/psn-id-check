require 'sinatra'

get '/' do
  'PSN ID Check'
end

get '/check' do
  erb :check
end