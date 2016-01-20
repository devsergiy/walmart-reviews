require 'net/http'
require 'json'

class Walmart

  API_KEY = "5aje7b5barsxara63d8tst8k"
  API_URL = "http://api.walmartlabs.com/v1/reviews/%s?format=json&apiKey=#{API_KEY}"

  def initialize(item_id, text)
    @item_id = item_id
    @show_all = text.empty?
    @words = text.split(" ")
  end

  def reviews
    reviews = get_reviews_json["reviews"]
    reviews.select do |review|
      @words.any? { |w| review["reviewText"] && review["reviewText"].include?(w) } or @show_all
    end
  end

  private

  def get_reviews_json
    url = URI.parse API_URL % [@item_id]
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }
    JSON.parse(res.body)
  end
end
