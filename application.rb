require 'sinatra'
require 'yaml'
require 'json'
require 'haml'
require 'sass'
require 'coffee_script'
require './models/bn_parser'

get '/' do
  @areas  = YAML.load_file "config/areas.yml"
  @houses = YAML.load_file "config/houses.yml"
  @wc     = YAML.load_file "config/wc.yml"

  haml :index
end

get '/search' do
  @results = BnParser.get_search_results(params)

  haml :results
end

get '/application.js' do
  coffee :application
end

get '/application.css' do
  sass :application
end
