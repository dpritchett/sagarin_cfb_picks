require 'sinatra'
require 'sinatra/jsonp'
require 'active_support/core_ext'
load    'pick_winners.rb'

get '/' do
  content_type :js
  callback = params.delete('callback')
  slate = params.delete('data')
  winners = picks_as_json pick_winners(slate)
  stuff = { winners: winners }
  "#{callback}(#{winners.to_json})"
end

get '/echo' do
  content_type :json
  STDERR.write(params.to_s)
  return params.to_json
end

post '/echo' do
  content_type :json
  STDERR.write(params.to_s)
  return params.to_json
end
