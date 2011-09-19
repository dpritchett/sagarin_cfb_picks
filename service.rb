require 'sinatra'
require 'sinatra/jsonp'
require 'active_support/core_ext'
load    'pick_winners.rb'

get '/' do
  content_type :js
  callback = params.delete('callback')
  slate = params.delete('data')

  picks = pick_winners slate
  print_winners picks

  winners = picks_as_json picks
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
