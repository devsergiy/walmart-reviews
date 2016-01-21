require './scrapper.rb'

class Walmart
  def initialize(item_id, text)
    @item_id = item_id
    @show_all = text.empty?
    @words = text.downcase.split(" ")
  end

  def reviews
    reviews = Scrapper.new(@item_id).reviews

    reviews.select do |review|
      @show_all or @words.any? { |w| review[:text].downcase.include?(w) }
    end
  end
end
