require 'sinatra'
require 'httparty'

get '/' do
  erb :check
end

get '/check/:name' do
  API_URL = "https://accounts.api.playstation.com/api/v1/accounts/onlineIds"
    resp = HTTParty.post(API_URL, 
      body: { onlineId: params['name'], reserveIfAvailable: false }.to_json,
      headers: { 'Content-Type' => 'application/json' })
    return { body: resp.body, status: resp.code }.to_json
end