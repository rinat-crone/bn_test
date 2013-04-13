require 'nokogiri'
require 'open-uri'

class BnParser
  KEYS_SET_10 = %w(image address floor house area_gross area_living price subject contacts info)
  KEYS_SET_14 = %w(image rooms address floor house area_gross area_living area_kitchen wc price mortgage subject contacts info)

  def self.get_search_results(params)
    page = Nokogiri::HTML(open(search_url(params), "User-Agent" => "Ruby/#{RUBY_VERSION}"))

    { results: parse_search_results(page),
      count:   detect_results_count(page) }
  end

  private

  def self.pack_params(params)
    params.map{ |key, value|
      value.is_a?(Array) ? value.map{ |v| "#{key}[]=#{v}" } : "#{key}=#{value}"
    }.join "&"
  end

  def self.search_url(params)
    "http://www.bn.ru/zap_fl.phtml?#{pack_params(params)}"
  end

  def self.parse_search_results(page)
    results_table = page.search 'table.results'

    [].tap do |r|
      results_table.search('tr.bg1, tr.bg2, tr.bg3').each do |tr|
        unless tr.search('th').any?
          r << {}
          tds = tr.search('td')
          keys_set = const_get "KEYS_SET_#{tds.size}"

          tds.each_with_index do |td, index|
            matches = td.inner_html.match %r{open_photo_image \(this, '(.*?)',}m
            link_matches = td.inner_html.scan %r{(detail/.*?)\"}m

            r.last[keys_set[index]] = (matches ? "http://static.bn.ru/images/photo/#{matches[1]}" : td.text.strip)
            r.last["link"] = "http://www.bn.ru/#{link_matches[0][0]}" if link_matches && link_matches.flatten.any?
          end
        end
      end
    end
  end

  def self.detect_results_count(page)
    page.search('strong.pag').first.text.match(%r{ (\d+)\.}m)[1].to_i
  rescue
    0
  end

end
