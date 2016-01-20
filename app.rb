require 'sinatra'
require './walmart'

get '/' do
  haml :form, layout: "layout"
end

post '/reviews' do
  @reviews = Walmart.new(params["item_id"], params["text"]).reviews
  haml :results
end
