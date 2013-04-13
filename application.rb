require 'sinatra'
require 'yaml'
require 'nokogiri'
require 'open-uri'
require 'json'

get '/' do
  @areas  = YAML.load_file "config/areas.yml"
  @houses = YAML.load_file "config/houses.yml"
  @wc     = YAML.load_file "config/wc.yml"

  haml :index
end

get '/search' do
  packed_params = params.map{ |k, v| "#{k}=#{v}" }.join "&"
  url = "http://www.bn.ru/zap_fl.phtml?#{packed_params}"
  page = Nokogiri::HTML(open(url, "User-Agent" => "Ruby/#{RUBY_VERSION}"))

  results_table = page.search 'table.results'
  results_stats = page.search('strong.pag').first.text

  results_count = results_stats.match(%r{ (\d+)\.}m)[1].to_i
  results = [].tap do |r|
    results_table.search('tr.bg1, tr.bg2, tr.bg3').each do |tr|
      unless tr.search('th').any?
        r << []

        tr.search('td').each do |td|
          matches = td.inner_html.match %r{open_photo_image \(this, '(.*?)',}m
          r.last << (matches ? "http://static.bn.ru/images/photo/#{matches[1]}" : td.text.strip)
        end
      end
    end
  end

  content_type :json

  { results: results,
    count: results_count }.to_json
end

get '/application.js' do
  coffee :application
end

get '/application.css' do
  sass :application
end
