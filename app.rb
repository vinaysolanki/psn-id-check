require 'sinatra'
require 'httparty'

API_URL = "https://accounts.api.playstation.com/api/v1/accounts/onlineIds"
HOST_URL = "psn-id-check.herokuapp.com"

get '/' do
  erb :check
end

get '/check/:name' do
    resp = HTTParty.post(API_URL, 
      body: { onlineId: params['name'], reserveIfAvailable: false }.to_json,
      headers: { 'Content-Type' => 'application/json', 'Host' => HOST_URL })
    return { body: resp.body, status: resp.code }.to_json
end