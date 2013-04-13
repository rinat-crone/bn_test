require 'sinatra'
require 'yaml'

get '/' do
  @areas  = YAML.load_file "config/areas.yml"
  @houses = YAML.load_file "config/houses.yml"
  @wc     = YAML.load_file "config/wc.yml"

  haml :index
end

get '/application.js' do
  coffee :application
end

get '/application.css' do
  sass :application
end
