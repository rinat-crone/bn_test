require 'sinatra'

get '/' do
  "Working!"
end

get '/application.js' do
  coffee :application
end
