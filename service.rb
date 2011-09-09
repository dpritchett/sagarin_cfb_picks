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
