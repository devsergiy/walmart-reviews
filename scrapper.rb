require 'mechanize'

class Scrapper
  URL = "https://www.walmart.com/reviews/product/%s?page=%d"

  def initialize(product_id)
    @id = product_id
  end

  def reviews
    mechanize = Mechanize.new
    page = mechanize.get(page_url(1))

    pages = page.search(".paginator-list li:last a")
    few_pages = pages.any?

    reviews = [collect_page_reviews(page)]

    return reviews.flatten unless few_pages

    page_count = pages.last.text.to_i
    (2..page_count).each do |page_num|
      sleep 0.2
      page = mechanize.get(page_url(page_num))
      reviews << collect_page_reviews(page)
    end

    reviews.flatten
  end

  def collect_page_reviews(page)
    reviews = page.search('.customer-review')
    reviews.map { |review| get_review_data(review) }
  end

  def get_review_data(review)
    {
      date: review.search(".customer-review-date.hide-content-m").first.text,
      text: review.search(".js-customer-review-text").first.text,
      name: review.search(".customer-name-heavy").first.text,
    }
  end

  def page_url(page_num)
    URL % [@id, page_num]
  end
end
