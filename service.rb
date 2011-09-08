require 'sinatra'
require 'sinatra/jsonp'
#require 'active_support/core_ext'
load    'pick_winners.rb'

get '/' do
  content_type :json
  jsonp picks_as_json pick_winners
end
