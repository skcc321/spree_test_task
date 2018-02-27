class ProductImporter::LineProcessor < BaseLineProcessor
  attr_reader :line,
    :errors

  NAME = 'name'.freeze
  DESCRIPTION = 'description'.freeze
  PRICE = 'price'.freeze
  AVAILABILITY_DATE = "availability_date".freeze
  SLUG = "slug".freeze
  STOCK_TOTAL = "stock_total".freeze
  CATEGORY = "category".freeze

  def initialize(line)
    @line = line
    @errors = []
  end

  def self.headers
    [
      nil,
      NAME,
      DESCRIPTION,
      PRICE,
      AVAILABILITY_DATE,
      SLUG,
      STOCK_TOTAL,
      CATEGORY
    ]
  end

  def perform
    # save records to DB
    return true if line.values.all?(&:blank?)

    product = Spree::Product.new(
      name: line[NAME],
      description: line[DESCRIPTION],
      available_on: line[AVAILABILITY_DATE],
      slug: line[SLUG],
      price: line[PRICE],
      shipping_category: Spree::ShippingCategory.take
    )

    begin
      product.save || add_error(product.errors.messages) && false
    rescue StandardError => e
      add_error(e.message) && false
    end
  end

  def add_error(error)
    @errors << error
  end
end
